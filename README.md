# Tmux Plugin Manager

[![Build Status](https://travis-ci.org/tmux-plugins/tpm.svg?branch=master)](https://travis-ci.org/tmux-plugins/tpm)

Installs and loads `tmux` plugins.

Tested and working on Linux, OSX, and Cygwin.

See list of plugins [here](https://github.com/tmux-plugins/list).

### Installation

Requirements: `tmux` version 1.9 (or higher), `git`, `bash`.

Clone TPM:

```bash
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Put this at the bottom of `~/.tmux.conf` (`$XDG_CONFIG_HOME/tmux/tmux.conf`
works too):

```bash
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```

Reload TMUX environment so TPM is sourced:

```bash
# type this in terminal if tmux is already running
$ tmux source ~/.tmux.conf
```

That's it!

### Installing plugins

1. Add new plugin to `~/.tmux.conf` with `set -g @plugin '...'`
2. Press `prefix` + <kbd>I</kbd> (capital i, as in **I**nstall) to fetch the plugin.

You're good to go! The plugin was cloned to `~/.tmux/plugins/` dir and sourced.

### Uninstalling plugins

1. Remove (or comment out) plugin from the list.
2. Press `prefix` + <kbd>alt</kbd> + <kbd>u</kbd> (lowercase u as in **u**ninstall) to remove the plugin.

All the plugins are installed to `~/.tmux/plugins/` so alternatively you can
find plugin directory there and remove it.

### Key bindings

`prefix` + <kbd>I</kbd>
- Installs new plugins from GitHub or any other git repository
- Refreshes TMUX environment

`prefix` + <kbd>U</kbd>
- updates plugin(s)

`prefix` + <kbd>alt</kbd> + <kbd>u</kbd>
- remove/uninstall plugins not on the plugin list

### Docs

- [Help, tpm not working](docs/tpm_not_working.md) - problem solutions

More advanced features and instructions, regular users probably do not need
this:

- [How to create a plugin](docs/how_to_create_plugin.md). It's easy.
- [Managing plugins via the command line](docs/managing_plugins_via_cmd_line.md)
- [Changing plugins install dir](docs/changing_plugins_install_dir.md)
- [Automatic TPM installation on a new machine](docs/automatic_tpm_installation.md)

### Tests

Tests for this project run on [Travis CI](https://travis-ci.org/tmux-plugins/tpm).

When run locally, [vagrant](https://www.vagrantup.com/) is required.
Run tests with:

```bash
# within project directory
$ ./run_tests
```

### License

[MIT](LICENSE.md)
