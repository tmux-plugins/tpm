# Tmux Plugin Manager

Installs and loads TMUX plugins.

### Installation

Requirements: `tmux` version 1.9 (or higher), `git`

Clone TPM:

    $ git clone https://github.com/bruno-/tpm ~/.tmux/plugins/tpm

Put this at the bottom of your `.tmux.conf` (backslashes at the end of the lines
are required):

    # List of plugins
    # Supports `github_username/repo` or full git URLs
    set -g @tpm_plugins "              \
      bruno-/tpm                       \
      bruno-/tmux_pain_control         \
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

- [pain control](https://github.com/bruno-/tmux_pain_control) - useful standard
  bindings for controlling panes
- [goto session](https://github.com/bruno-/tmux_goto_session) - faster session
  switching
- [battery osx](https://github.com/bruno-/tmux_battery_osx) - battery status
  for OSX in Tmux `status-right`
- [logging](https://github.com/bruno-/tmux_logging) - easy logging and
  screen capturing
- [online status](https://github.com/bruno-/tmux_online_status) - online status
  indicator in Tmux `status-right`. Useful when on flaky connection to see if
  you're online.

If you create a plugin, feel free to create a pull request that adds it to the
list.

### Creating plugins

[How to create a plugin](HOW_TO_PLUGIN.md). It's easy.

### Tests

Requirements: [vagrant](https://www.vagrantup.com/)

To run a test suite:

    $ ./run-tests

### About

Truth be told, there aren't too many TMUX plugins out there. People mostly just
copy code snippets from each others' `.tmux.conf` files.

I hope TMUX plugin manager (TPM) inspires people to do better and more creative
things with TMUX.

### License

[MIT](LICENSE.md)
