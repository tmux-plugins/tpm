# Changelog

### master
- if the plugin is not downloaded do not source it
- remove `PLUGINS.md`, an obsolete list of plugins
- update readme with instructions about uninstalling plugins
- tilde char and `$HOME` in `TMUX_SHARED_MANAGER_PATH` couldn't be used because
  they are just plain strings. Fixing the problem by manually expanding them.

### v1.0.0, 2014-08-05
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
- add test for updating a plugin

### v0.0.2, 2014-07-17
- run all *.tmux plugin files as executables
- fix all redirects to /dev/null
- fix bug: TPM shared path is created before sync (cloning plugins from github
  is done)
- add test suite running in Vagrant
- add Tmux version check. `TPM` won't run if Tmux version is less than 1.9.

### v0.0.1, 2014-05-21
- get TPM up and running
