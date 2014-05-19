# Tmux Plugin Manager

Installs and loads TMUX plugins.

Truth be told, there aren't too many TMUX plugins out there. People mostly just
copy code snippets from each others' `.tmux.conf` files.

I hope TMUX plugin manager (TPM) inspires people to do better and more creative
things with TMUX. See below for instructions how to create your own plugin.

### Installation

Requirements: `git`

Clone TPM:

    $ git clone https://github.com/bruno-/tpm ~/.tmux/plugins/tpm

Put this at the bottom of your `.tmux.conf` (backslashes at the end of the lines
are required):

    # List of plugins
    # Supports `github_username/repo` or full git URLs
    set -g @tpm_plugins "              \
      bruno-/tpm                       \
      bruno-/tmux_battery_osx          \
      # Examples:
      # github_username/plugin_name    \
      # git@github.com/user/plugin     \
      # git@bitbucket.com/user/plugin  \
    "

    # initializes TMUX plugin manager
    run-shell ~/.tmux/plugins/tpm/tpm.sh

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

### Creating plugins

### License

[MIT](LICENSE.md)
