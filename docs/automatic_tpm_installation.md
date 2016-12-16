# Automatic tpm installation

One of the first things we do on a new machine is cloning our dotfiles. Not everything comes with them though, so for example `tpm` most likely won't be installed.

If you want to install `tpm` and plugins automatically when tmux is started, put the following snippet in `.tmux.conf` before the final `run '~/.tmux/plugins/tpm/tpm'`:

```
if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"
```

This useful tip was submitted by @acr4 and narfman0.
