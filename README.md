# Tmux Plugin Manager

[![Build Status](https://travis-ci.org/tmux-plugins/tpm.png?branch=master)](https://travis-ci.org/tmux-plugins/tpm)

Installs and loads TMUX plugins.

### Installation

Requirements: `tmux` version 1.9 (or higher), `git`, `bash`.

Clone TPM:

    $ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Put this at the bottom of your `.tmux.conf` (backslashes at the end of the lines
are required):

    # List of plugins
    # Supports `github_username/repo` or full git repo URLs
    set -g @tpm_plugins '              \
      tmux-plugins/tpm                 \
      tmux-plugins/tmux-sensible       \
    '
    # Other examples:
    # github_username/plugin_name    \
    # git@github.com/user/plugin     \
    # git@bitbucket.com/user/plugin  \

    # Initializes TMUX plugin manager.
    # Keep this line at the very bottom of tmux.conf.
    run-shell '~/.tmux/plugins/tpm/tpm'

Reload TMUX environment so TPM is sourced:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

That's it!

### Installing plugins

1. add a new plugin to the `@tpm_plugins` list
2. hit `prefix + I` (I as in *I*nstall) to fetch the plugin

You're good to go! The plugin was cloned to `~/.tmux/plugins/` dir and sourced.

### Uninstalling plugins

1. remove plugin from `@tpm_plugins` list
2. All the plugins are installed to `~/.tmux/plugins/`. Find plugin
  directory there and just remove it.

### Key bindings

`prefix + I`
- installs new plugins from github or any other git repo
- refreshes TMUX environment

`prefix + U`
- updates plugin(s)

### List of plugins

For more plugins, check [here](https://github.com/tmux-plugins).

### Wiki pages

More advanced features, regular users probably do not need this:

- [installing plugins via the command line](https://github.com/tmux-plugins/tpm/wiki/Installing-plugins-via-the-command-line-only)
- [changing plugins install dir](https://github.com/tmux-plugins/tpm/wiki/Changing-plugins-install-dir)

### Creating plugins

[How to create a plugin](HOW_TO_PLUGIN.md). It's easy.

### Tests

Tests run on [travis](https://travis-ci.org/tmux-plugins/tpm).

When run locally, [vagrant](https://www.vagrantup.com/) is required.
Run tests with:

    # within project directory
    $ ./run-tests

### Other goodies

- [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) - a plugin for
  regex searches in tmux and fast match selection
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - enables copying
  highlighted text to system clipboard
- [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for quickly
  opening highlighted file or a url
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) - automatic
  restoring and continuous saving of tmux env

You might want to follow [@brunosutic](https://twitter.com/brunosutic) on
twitter if you want to hear about new tmux plugins or feature updates.

### License

[MIT](LICENSE.md)
