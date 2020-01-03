---
title: Mozilla Weave on Ubuntu using lighttpd
---

kind: article
---
Now that I got a Lenovo X200, decided to use Mozilla Weave to sync Firefox 3 across all my computers. In short, this involves getting WebDAV and mod_auth working on lighttpd.

### Enabling WebDAV and mod_auth on Ubuntu

```console
$ lighty-enable-mod
$ sudo apt-get install lighttpd-mod-webdav
```

```conf
server.modules = (
  ...
  "mod_webdav",
  ...
)

$HTTP["host"] =~ "weave.foo.com" {
  server.document-root = "/foo/weave"
  accesslog.filename = "/var/log/lighttpd/weave/access.log"
  webdav.activate = "enable"
  webdav.is-readonly = "disable"
  webdav.sqlite-db-name = "/var/run/lighttpd/lighttpd.webdav_lock.db"
  auth.backend = "htpasswd"
  auth.backend.htpasswd.userfile = "/foo/weave/passwd.dav"
  auth.require = ( "" => ( "method" => "basic",
                           "realm" => "webdav",
                           "require" => "valid-user" ) )
}
```

### Generating the htpasswd file and fixing permissions

```console
$ sudo apt-get install apache2-utils

$ sudo chown www-data:www-data /foo/weave
$ sudo -u www-data htpasswd -c /foo/weave/passwd.dav [username]
$ sudo -u www-data chmod 600 passwd.dav
```

Lastly, the latest Weave bits can be downloaded [here](http://people.mozilla.com/~cbeard/weave/dist/latest-weave.xpi). It takes a couple tries to get it working, but you’ll need to fix the server in preferences and then sign in using the created user:pass in the passwd.dav file.
