# Installing plugins via the command line only

### From inside tmux

When you have `tmux` running, plugins can be installed with the following command:

    ~/.tmux/plugins/tpm/scripts/install_plugins.sh

This is the equivalent of pressing `prefix + I`.

### From outside tmux

To install the plugins when `tmux` is not even started (for example in a provisioning script):

    # start tmux and create a session but don't attach to it
    tmux new-session -d
    # install the plugins
    tmux run "~/.tmux/plugins/tpm/scripts/install_plugins.sh"
    # killing the session is not required
    tmux kill-session
