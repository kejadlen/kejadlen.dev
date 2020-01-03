---
title: Addressbar keywords in IE
---

Apparently, you can actually use keywords in IE, just like you would with
Firefox. Except that creating them is much more of a pain. You need to go into
the registry and add a new key under `HKCU/Software/Microsoft/Internet
Explorer/SearchUrl/`. The name of the key will be the keyword and the default
value the URL. Just like with Firefox, a `%s` in the URL will be replaced by
any words following the keyword when you use it.

Crazy.
