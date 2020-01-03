---
title: WebDAV on lighttpd
---

I did this to use [XMarks](http://www.xmarks.com/) on my own server. In `lighttpd.conf`:

```conf
$HTTP["host"] =~ "xmarks.foobar.com" {
  server.document-root = "/path/to/xmarks/dir"
  webdav.activate = "enable"
  webdav.is-readonly = "disable"
  webdav.sqlite-db-name = "/var/run/lighttpd/lighttpd.webdav_lock.db"
  auth.backend = "htdigest"
  auth.backend.htdigest.userfile = "/path/to/xmarks/dir/.passwd"
  auth.require = ( "" => ( "method" => "digest",
                           "realm" => "webdav",
                           "require" => "valid-user" ) )
```

Then on the command line:

```console
$ sudo apt-get install apache2-utils
$ cd /path/to/xmarks/dir
$ htdigest -c .passwd webdav USERNAME
```
