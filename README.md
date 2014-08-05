# Tmux Plugin Manager

Installs and loads TMUX plugins.

### Installation

Requirements: `tmux` version 1.9 (or higher), `git`

Clone TPM:

    $ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

Put this at the bottom of your `.tmux.conf` (backslashes at the end of the lines
are required):

    # List of plugins
    # Supports `github_username/repo` or full git URLs
    set -g @tpm_plugins "              \
      tmux-plugins/tpm                 \
      tmux-plugins/tmux-sensible       \
    "
    # Other examples:
    # github_username/plugin_name    \
    # git@github.com/user/plugin     \
    # git@bitbucket.com/user/plugin  \

    # initializes TMUX plugin manager
    run-shell ~/.tmux/plugins/tpm/tpm

Reload TMUX environment so TPM is sourced:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

That's it!

### Installing plugins

1. add a new plugin to the `@tpm_plugins` list
2. hit `prefix + I` (I as in *I*nstall) to fetch the plugin

You're good to go! The plugin was cloned to `~/.tmux/plugins/` dir and sourced.

### Key bindings

TPM provides only 1 key binding: `prefix + I`. Here's what it does:

- clones new plugins from github or any other git repo
- pulls updates for already installed plugins
- refreshes TMUX environment

After you press `prefix + I`, everything should be up to date.

### List of plugins

For more plugins, check [here](https://github.com/tmux-plugins).

### Creating plugins

[How to create a plugin](HOW_TO_PLUGIN.md). It's easy.

### Tests

Requirements: [vagrant](https://www.vagrantup.com/)

To run a test suite:

    $ ./run-tests

### License

[MIT](LICENSE.md)
