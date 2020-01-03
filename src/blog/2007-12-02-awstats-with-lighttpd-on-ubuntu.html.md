---
title: AWStats with lighttpd on Ubuntu
---

Throughout this post, I’ll use `foobar` as a fake domain. You should replace this with the appropriate domain(s) for your own use.

First, install AWStats.

```console
$ sudo apt-get install awstats
```

`/etc/lighttpd.conf` will need to be modified; this will be slightly different if you want to use a directory instead of a subdomain to check your stats.

### /etc/lighttpd/lighttpd.conf

```conf
server.modules += ( "mod_cgi" )

$HTTP["host"] =~ "stats.foobar" {
  alias.url = ( "/icon/" => "/usr/share/awstats/icon/",
                "/css/" => "/usr/share/doc/awstats/examples/css/",
                "/cgi-bin/" => "/usr/lib/cgi-bin/" )
  cgi.assign = ( ".pl" => "/usr/bin/perl", ".cgi" => "/usr/bin/perl" )
}
```

Make sure this works by visiting `http://stats.foobar/cgi-bin/awstats.pl`. You should get an error message from the AWStats CGI file.

In `/etc/awstats`, make a `awstats.foobar.conf` file, replacing `foobar` with whatever is appropriate for your purposes.

### /etc/awstats/awstats.foobar.conf

```conf
LogFile="/var/log/lighttpd/access.log"
LogType=W
LogFormat=1
SiteDomain="foobar"
HostAliases="localhost 127.0.0.1 REGEX[foobar$]"
DNSLookup=1
DirData="/var/lib/awstats"
DirCgi="/cgi-bin"
DirIcons="/icon"
SkipHosts="127.0.0.1 localhost REGEX[^192\.168\.]"
```

Run `awstats.pl` to initialize the statistics database.

```console
$ sudo -u www-data /usr/lib/cgi-bin/awstats.pl -config=foobar -update
```

Your stats should now be visible at `http://stats.foobar/cgi-bin/awstats.pl?config=foobar`.

Now all that’s left is editing the crontab and logrotate configuration files to automatically populate the stats.

### /etc/cron.d/awstats

```cron
0,10,20,30,40,50 * * * * www-data [ -x /usr/lib/cgi-bin/awstats.pl -a -f /etc/awstats/awstats.foobar.conf -a -r /var/log/lighttpd/access.log ] &amp;&amp; /usr/lib/cgi-bin/awstats.pl -config=foobar -update >/dev/null
```

### /etc/logrotate.d/lighttpd

```conf
prerotate
  /usr/lib/cgi-bin/awstats.pl -config=foobar -update
endscript
```
