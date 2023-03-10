This tool allows the conversion of Mercurial repositories to Git.

It's based on the code of
[git-remote-hg](https://github.com/felipec/git-remote-hg), which itself was
based on Rocco Rutte's hg-fast-export, which is now maintained by
Frej Drejhammar and lives on [hg-fast-export](https://github.com/frej/fast-export).

To use it simply do:

```
git init git-repo
cd git-repo
hg-fast-export hg-repo | git fast-import
git checkout
```

It's very limited at the moment, but it works.

## Rationale

Why `hg-fast-export`? While there's many existing tools that do a fine job
converting hg repos, many are doing workarounds for ancient versions of hg
which are not needed in 2023, or have too many features (yes, I said that)
which obfuscate the logic.

In the spirit of the thinking of Jim Keller, `hg-fast-export` is going to
attempt to recreate what many tools already do, but simpler... and better. As
Jim says: software should be rewritten every five years.

With only 112 lines of code (at the moment of writing) this tool is already
quite useful.
