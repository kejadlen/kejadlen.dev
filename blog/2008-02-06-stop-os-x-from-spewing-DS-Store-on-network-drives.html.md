---
title: Stop OS X from spewing .DS_Store on network drives
...

This is something that should be widely known by now, but is strangely not.

```console
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```

This will come in useful later on when I post on how to use NFS and SMB to share files between Ubuntu and OS X.
