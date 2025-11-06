## Automatic tpm installation

One of the first things we do on a new machine is cloning our dotfiles. Not everything comes with them though, so for example `tpm` most likely won't be installed.

If you want to install `tpm` and plugins automatically when tmux is started, put the following snippet in `.tmux.conf` before the final `run '~/.tmux/plugins/tpm/tpm'`:

**Note:** The examples below use `$XDG_CONFIG_HOME` to store tmux plugins, which is a more modern approach than the traditional `~/.tmux` folder. If you prefer to use `~/.tmux` instead, simply replace `$XDG_CONFIG_HOME/tmux` with `~/.tmux` in the commands below.

```tmux
if "test ! -d $XDG_CONFIG_HOME/tmux/plugins/tpm" \
  "run 'git clone https://github.com/tmux-plugins/tpm $XDG_CONFIG_HOME/tmux/plugins/tpm'"

if "test -d $XDG_CONFIG_HOME/tmux/plugins/tpm/.git" \
  "run 'rm -rf $XDG_CONFIG_HOME/tmux/plugins/tpm/.git/'"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '$XDG_CONFIG_HOME/tmux/plugins/tpm/tpm'

if "test -x $XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins" \
  "run '$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins'"
```

This useful tip was submitted by @acr4 and narfman0 and @raulvictorrosa.
