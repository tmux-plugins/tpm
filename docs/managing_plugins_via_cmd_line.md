# Managing plugins via the command line

Aside from tmux key bindings, TPM provides shell interface for managing plugins
via scripts located in [bin/](../bin/) directory.

Tmux does not need to be started in order to run scripts (but it's okay if it
is). If you [changed tpm install dir](../docs/changing_plugins_install_dir.md)
in `.tmux.conf` that should work fine too.

Prerequisites:

- tmux installed on the system (doh)
- `.tmux.conf` set up for TPM

### Installing plugins

As usual, plugins need to be specified in `.tmux.conf`. Run the following
command to install plugins:

    ~/.tmux/plugins/tpm/bin/install_plugins

### Updating plugins

To update all installed plugins:

    ~/.tmux/plugins/tpm/bin/update_plugins all

or update a single plugin:

    ~/.tmux/plugins/tpm/bin/update_plugins tmux-sensible

### Removing plugins

To remove plugins not on the plugin list:

    ~/.tmux/plugins/tpm/bin/clean_plugins
