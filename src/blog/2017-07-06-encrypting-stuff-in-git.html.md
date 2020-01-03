---
title: Encrypting Stuff in Git
---

**Disclaimer:** *You probably don't want to use this technique for real
secrets/projects, for a variety of reasons. If you don't know what you're
doing, you should avoid doing this.*

With that being said, sometimes you just want to store an encrypted file in git
without jumping through a lot of hoops.

We begin by adding an `encrypt` filter in git. This assumes that `openssl` is
installed and that the encryption password is in an environment variable named
`ENC_PWD`. (I personally use [direnv][direnv] to manage the latter, with
`.envrc` in my global `.gitignore` file.)

```console
$ git config filter.encrypt.clean "openssl aes-256-cbc -S '' -pass env:ENC_PWD"'
$ git config filter.encrypt.smudge "openssl aes-256-cbc -d -S '' -pass env:ENC_PWD"'
```

This sets up [clean/smudge][clean-smudge] filters so that files will live
decrypted on the filesystem, but will be encrypted in git itself. This is
automatically done by git, so there are no extra steps in the git workflow.

Once this is done, you'll need to specify what files to encrypt in the
`.gitattributes` file:

```
secrets.txt filter=encrypt
```

And that's it!

Actually pretty straightforward, but this doesn't come without some
disadvantages:

- Most people have no idea about git's clean/smudge filters, and it's
  non-obvious for even experienced git users to tell that the secrets are
  actually encrypted inside of git. If anything goes wrong, most people are
  going to be extremely confused.
- Cloning a new repo without having the encrypt filter config will result in
  the secrets file not being decrypted (since how would git even know to do
  so?). IIRC, git doesn't even warn about the filter not existing. And then
  getting git to decrypt the file after installing the filter requires poking
  git /just so/ to get it to reset the file.

Once it is set up and working though, it is a pretty seamless experience.
Updating secrets doesn't require any additional steps, and ditto with pulling
down a new version.

[clean-smudge]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes
[direnv]: https://direnv.net/
