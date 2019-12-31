---
title: A little known operator in C++
...

Introducing the `-->` operator!

```cpp
#include <stdio.h>
int main()
{
     int x = 10;
     while( x --> 0 ) // x goes to 0
     {
       printf("%d ", x);
     }
}
```

Via [Stack Overflow](http://stackoverflow.com/questions/1642028/what-is-the-name-of-this-operator).
