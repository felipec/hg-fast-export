This tool allows the conversion of Mercurial repositories to Git.

It's based on the code of
[git-remote-hg](https://github.com/felipec/git-remote-hg), which itself was
based on Rocco Rutte's hg-fast-export, which is now maintained by
Frej Drejhammar and lives on [hg-fast-export](https://github.com/frej/fast-export).

To use it simple do:

```
git init git-repo
cd git-repo
hg-fast-export hg-repo | git fast-import
git checkout
```

It's very limited at the moment, but it works.
