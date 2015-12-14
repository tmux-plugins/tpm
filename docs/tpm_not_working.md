# Help, tpm not working!

Here's the list of issues users had with `tpm`:

> Nothing works. `tpm` key bindings `prefix + I`, `prefix + U` not even
  defined.

[Issue #22](https://github.com/tmux-plugins/tpm/issues/22)

- Do you have required `tmux` version to run `tpm`?<br/>
  Check `tmux` version with `$ tmux -V` command and make sure it's higher or
  equal to the required version for `tpm` as stated in the readme.

- ZSH tmux plugin might be causing issues.<br/>
  If you have it installed, try disabling it and see if `tpm` works then.

> Help, I'm using custom config file with `tmux -f /path/to/my_tmux.conf`
to start Tmux and for some reason plugins aren't loaded!?

[Issue #57](https://github.com/tmux-plugins/tpm/issues/57)

`tpm` has a known issue when using custom config file with `-f` option.
The solution is to use alternative plugin definition syntax. Here are the steps
to make it work:

1. remove all `set -g @plugin` lines from tmux config file
2. in the config file define the plugins in the following way:

        # List of plugins
        set -g @tpm_plugins '          \
          tmux-plugins/tpm             \
          tmux-plugins/tmux-sensible   \
          tmux-plugins/tmux-resurrect  \
        '

        # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
        run '~/.tmux/plugins/tpm/tpm'

3. Reload TMUX environment so TPM is sourced: `$ tmux source /path/to/my_tmux.conf`

The plugins should now be working.

> Weird sequence of characters show up when installing or updating plugins

[Issue #25](https://github.com/tmux-plugins/tpm/issues/25)

- This could be caused by [tmuxline.vim](https://github.com/edkolev/tmuxline.vim)
  plugin. Uninstall it and see if things work.

> "failed to connect to server" error when sourcing .tmux.conf

[Issue #48](https://github.com/tmux-plugins/tpm/issues/48)

- Make sure `tmux source ~/.tmux.conf` command is ran from inside `tmux`.
