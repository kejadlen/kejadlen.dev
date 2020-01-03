---
title: pbpaste and pbcopy in Windows
---

Indeed, it is true. And as an added bonus, you also get a snippet of my `.bash_profile` in Cygwin.

### pbcopy.cmd

```
@ruby "c:/Documents and Settings/alphach.redmond/bin/pbcopy.rb"
```

### pbcopy.rb

```ruby
#!/usr/bin/env ruby

require 'win32/clipboard'

Win32::Clipboard.set_data(ARGF.read)
```

### pbpaste.cmd

```
@ruby "c:/Documents and Settings/alphach.redmond/bin/pbpaste.rb"
```

### pbpaste.rb

```ruby
#!/usr/bin/env ruby

require 'win32/clipboard'

puts Win32::Clipboard.data
```

### .bash_profile

```bash
if $cygwin; then
  alias pbpaste=/home/alphach/bin/pbpaste.cmd
  alias pbcopy=/home/alphach/bin/pbcopy.cmd
fi
```

This aliasing is a hack to properly use pbpaste without calling pbpaste.cmd. Basically, being able to write `pbpaste > temp.txt` instead of `pbpaste.cmd > temp.txt`. Currently, Cygwin’s automatic command aliasing isn’t working quite right. I’m going to look into it when I have the time.

**Edit**: I later discovered that `getclip` and `putclip` accomplish the same thing in Cygwin, so I can just alias `pbcopy` and `pbpaste` to those commands! No need for all this hassle.
