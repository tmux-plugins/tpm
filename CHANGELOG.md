# Changelog

### master
- update readme because of github organization change to
  [tmux-plugins](https://github.com/tmux-plugins)
- update tests to pass
- update README to suggest different first plugin

### v0.0.2, 2014-07-17
- run all *.tmux plugin files as executables
- fix all redirects to /dev/null
- fix bug: TPM shared path is created before sync (cloning plugins from github
  is done)
- add test suite running in Vagrant
- add Tmux version check. `TPM` won't run if Tmux version is less than 1.9.

### v0.0.1, 2014-05-21
- get TPM up and running
