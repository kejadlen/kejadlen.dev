---
title: Git submodule woes
---

So, I <3 git submodules (and use them extensively for organizing my personal
repos), but there are moments where knowing a bit about how they work under the
hood becomes invaluable. This is the second time I've hit this particular
issue, so I thought I'd document it for future posterity.

I've found that for the most part, you can stay out of trouble with submodules
in personal repos by staying on the well-trodden path, but changes in
submodules in an upstream repo can have unexpected results.

Namely, this is the error that I saw when the upstream repo changed the URL of
a submodule:

```shell
❯ git submodule update --checkout
error: Server does not allow request for unadvertised object 3ad94b659910c775a6560c45b1524d23d8c83b09
Fetched in submodule path 'modules/prompt/external/agnoster', but it did not contain 3ad94b659910c775a6560c45b1524d23d8c83b09. Direct fetching of that commit failed.
```

I won't go into details for how I figured out the root cause, partially since I
had seen this same error in the past and have long since forgotten how I
diagnosed it back then. Regardless, I knew that it was an issue with the remote
URL for the upstream repo.

My gut says that there's probably a git submodule command you can run to
re-init all of those, but it was faster for me to just edit the git config
directly for the submodule.

The actual location in my case is a little strange since it's a submodule
within another submodule, but the main thing you need to know is that the git
config folder for a submodule is located in the `.git/modules` folder, with the
same path as in the actual repo. You can see in the path below that the first
submodule is at `src/prezto` and the second one at
`modules/prompt/external/agnoster/config`.

`.git/modules/src/prezto/modules/modules/prompt/external/agnoster/config`

Opening this config up revealed the following git remote:

```conf
[remote "origin"]
  url = https://gist.github.com/3712874.git
  fetch = +refs/heads/*:refs/remotes/origin/*
```

A quick look at the [canonical prezto repo][prezto-repo] showed what the
`agnoster` remote URL should be:

[prezto-repo]: https://github.com/sorin-ionescu/prezto/tree/master/modules/prompt/external

```conf
[remote "origin"]
  url = https://github.com/agnoster/agnoster-zsh-theme.git
  fetch = +refs/heads/*:refs/remotes/origin/*
```

And with that done, running `git submodule update --checkout` worked.
