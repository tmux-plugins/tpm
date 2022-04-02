# Automatic tpm installation

One of the first things we do on a new machine is cloning our dotfiles. Not everything comes with them though, so for example `tpm` most likely won't be installed.

If you want to install `tpm` and plugins automatically when tmux is started, put the following snippet in `.tmux.conf` before the final `run '~/.tmux/plugins/tpm/tpm'`:


```bash
# this patch fix errors 
if [ -e "~/.tmux/plugins/tpm" ]
then
   echo "that exist."
else
 git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm ; ~/.tmux/plugins/tpm/bin/install_plugins 
fi
```

This useful tip was submitted by @0x07CB AKA Rick Sanchez and @acr4 and narfman0.
