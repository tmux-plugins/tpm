# Installing plugins via the command line only

Run the following command to install plugins:

    ~/.tmux/plugins/tpm/bin/install_plugins

Tmux does not need to be started in order to run the script (but it's okay if it
is).

If you [changed tpm install dir](docs/changing_plugins_install_dir.md) in
`.tmux.conf` that should work fine too.

Prerequisites:

- tmux installed on the system (doh)
- `.tmux.conf` set for TPM
