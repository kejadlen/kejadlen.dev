---
title: Sharing from WHS to Ubuntu
---

It took me a little while to put this all together, but here’s my configuration. Sharing from an HP MediaSmart to Ubuntu 8.10. I’m not sure if smbfs is required, since I’m using cifs.

```console
$ apt-get install smbfs winbind
```

### /etc/fstab

```conf
//foo/bar /mnt/foo cifs rw,uid=1000,gid=1000,auto,file_mode=0644,dir_mode=0755,credentials=/root/.smb_credentials 0 0
```

### /root/.smb_credentials

```conf
username=foo
password=bar
```

uid and gid set the permissions on the share to my user account. file_mode and dir_mode are there to make the permissions on the files and directories correct.

Don’t forget to make sure `.smb_credentials` are properly `chown`'ed to root and `chmod`'ed to 600 so that no one else can read them!
