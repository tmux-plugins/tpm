# Changing plugins install dir

By default, TPM installs plugins to `~/.tmux/plugins/`.

You can change the install path by putting this in `.tmux.conf`:

    set-environment -g TMUX_PLUGIN_MANAGER_PATH '/some/other/path/'

Tmux plugin manager initialization in `.tmux.conf` should also be updated:

    # initializes TMUX plugin manager in a new path
    run /some/other/path/tpm/tpm

Please make sure that the `run` line is at the very bottom of `.tmux.conf`.
