# Changelog

### master

### v3.1.0, 2023-01-03
- upgrade to new version of `tmux-test`
- bug: when using `emacs` copy mode, Enter does not quit screen after tpm
  installation/update. Fix by making `Escape` the key for emacs mode.
- add a doc with troubleshooting instructions
- add `.gitattributes` file that forces linefeed characters (classic `\n`) as
  line endings - helps with misconfigured git on windows/cygwin
- readme update: announce Cygwin support
- un-deprecate old plugin definition syntax: `set -g @tpm_plugins`
- More stuff, check `git log`.

### v3.0.0, 2015-08-03
- refactor `shared_set_tpm_path_constant` function
- move all instructions to `docs/` dir
- add `bin/install_plugins` cli executable script
- improved test runner function
- switch to using [tmux-test](https://github.com/tmux-plugins/tmux-test)
  framework
- add `bin/update_plugins` cli executable script
- refactor test `expect` scripts, make them simpler and ensure they properly
  assert expectations
- refactor code that sets 'TMUX_PLUGIN_MANAGER_PATH' global env var
- stop using global variable for 'tpm path'
- support defining plugins via `set -g @plugin` in sourced files as well

### v2.0.0, 2015-07-07
- enable overriding default key bindings
- start using `C-c` to clear screen
- add uninstall/clean procedure and keybinding (prefix+alt+u) (@chilicuil)
- add new `set @plugin 'repo'` plugin definition syntax (@chilicuil)
- revert back to using `-g` flag in new plugin definition syntax
- permit leading whitespace with new plugin definition syntax (thanks @chilicuil)
- make sure `TMUX_PLUGIN_MANAGER_PATH` always has trailng slash
- ensure old/deprecated plugin syntax `set -g @tpm_plugins` works alongside new
  `set -g @plugin` syntax

### v1.2.2, 2015-02-08
- set GIT_TERMINAL_PROMPT=0 when doing `git clone`, `pull` or `submodule update`
  to ensure git does not prompt for username/password in any case

### v1.2.1, 2014-11-21
- change the way plugin name is expanded. It now uses the http username
  and password by default, like this: `https://git::@github.com/`. This prevents
  username and password prompt (and subsequently tmux install hanging) with old
  git versions. Fixes #7.

### v1.2.0, 2014-11-20
- refactor tests so they can be used on travis
- add travis.yml, add travis badge to the readme

### v1.1.0, 2014-11-19
- if the plugin is not downloaded do not source it
- remove `PLUGINS.md`, an obsolete list of plugins
- update readme with instructions about uninstalling plugins
- tilde char and `$HOME` in `TMUX_SHARED_MANAGER_PATH` couldn't be used because
  they are just plain strings. Fixing the problem by manually expanding them.
- bugfix: fragile `*.tmux` file globbing (@majutsushi)

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
