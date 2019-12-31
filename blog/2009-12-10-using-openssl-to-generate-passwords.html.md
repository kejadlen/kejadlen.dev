---
title: Using openssl to generate passwords
...

When I need to create a password, I use this nifty aspect of `openssl` from the command line:

```console
$ openssl rand -base64 6
```

Works like a charm for generating passwords in the range `[a-zA-Z0-9]`.

**Edit:** Nowdays, I just use [1Password](https://agilebits.com/onepassword).
