---
title: A Tabata timer in Go
---

A friend of mine was recently talking about doing interval training, and it sounded like a good way to play around with [Go](http://golang.org/doc/).

```go
package main

import (
  "flag"
  "fmt"
  "os/exec"
  "time"
)

type Tabata struct {
  cycles int
  on int
  off int
  delay int

  currentCycle int
  timeLeft int
  exercising bool

  done chan bool
}

func NewTabata(cycles int, on int, off int, delay int) *Tabata {
  var timeLeft int
  if delay > 0 {
    timeLeft = delay + 1
  } else {
    timeLeft = on
  }

  t := Tabata{cycles, on, off, delay, 1, timeLeft, true, make(chan bool)}
  return &t
}

func Say(format string, a ...interface{}) {
  str := fmt.Sprintf(format, a...)
  c := exec.Command("say", "-v", "Victoria", str)
  c.Start()
}

func DoTick(tabata *Tabata) {
  if tabata.currentCycle == tabata.cycles * 2 {
    Say("Done")
    tabata.done <- true
  }

  if tabata.delay > 0 {
    switch {
    case tabata.timeLeft == 0:
      Say("Go")

      tabata.delay = 0
      tabata.timeLeft = tabata.on
    case tabata.timeLeft > tabata.delay:
      Say("Starting in")
    case tabata.timeLeft <= tabata.delay:
      Say("%d", tabata.timeLeft)
    }

    tabata.timeLeft -= 1

    return
  }

  switch {
  case tabata.timeLeft == 0:
    tabata.currentCycle += 1
    tabata.exercising = !tabata.exercising

    if tabata.exercising {
      Say("Go")
      tabata.timeLeft = tabata.on
    } else {
      Say("Stop")
      tabata.timeLeft = tabata.off
    }
  case tabata.timeLeft % 10 == 0:
    Say("%d seconds remaining", tabata.timeLeft)
  case tabata.timeLeft == 5:
    Say("%d seconds", tabata.timeLeft)
  case tabata.timeLeft < 5:
    Say("%d", tabata.timeLeft)
  case tabata.exercising && tabata.timeLeft % 2 == 0:
    Say("Work")
  }

  tabata.timeLeft -= 1
}

func main() {
  cycles := flag.Int("cycles", 20, "number of cycles")
  on := flag.Int("on", 20, "seconds of exercise")
  off := flag.Int("off", 10, "seconds of rest")
  delay := flag.Int("delay", 5, "delay before starting")

  flag.Parse()

  tabata := NewTabata(*cycles, *on, *off, *delay)

  ticker := time.Tick(time.Second)
  go func () {
    for {
      select {
      case <- ticker:
        DoTick(tabata)
      }
    }
  }()

  <-tabata.done
}
```
