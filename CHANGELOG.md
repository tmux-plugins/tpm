# Changelog

### master
- update readme because of github organization change to
  [tmux-plugins](https://github.com/tmux-plugins)
- update tests to pass
- update README to suggest different first plugin
- update list of plugins in the README
- remove README 'about' section
- move key binding to the main file. Delete `key_binding.sh`.
- rename `display_message` -> `echo_message`
- installing plugins installs just new plugins. Already installed plugins aren't
  updated.
- add 'update plugin' binding and functionality

### v0.0.2, 2014-07-17
- run all *.tmux plugin files as executables
- fix all redirects to /dev/null
- fix bug: TPM shared path is created before sync (cloning plugins from github
  is done)
- add test suite running in Vagrant
- add Tmux version check. `TPM` won't run if Tmux version is less than 1.9.

### v0.0.1, 2014-05-21
- get TPM up and running
