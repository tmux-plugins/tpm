# Help, tpm not working!

Here's the list of issues users had with `tpm`:

<hr />

> Nothing works. `tpm` key bindings `prefix + I`, `prefix + U` not even
  defined.

Related [issue #22](https://github.com/tmux-plugins/tpm/issues/22)

- Do you have required `tmux` version to run `tpm`?<br/>
  Check `tmux` version with `$ tmux -V` command and make sure it's higher or
  equal to the required version for `tpm` as stated in the readme.

- ZSH tmux plugin might be causing issues.<br/>
  If you have it installed, try disabling it and see if `tpm` works then.

<hr />

> Help, I'm using custom config file with `tmux -f /path/to/my_tmux.conf`
to start Tmux and for some reason plugins aren't loaded!?

Related [issue #57](https://github.com/tmux-plugins/tpm/issues/57)

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

<hr />

> Weird sequence of characters show up when installing or updating plugins

Related: [issue #25](https://github.com/tmux-plugins/tpm/issues/25)

- This could be caused by [tmuxline.vim](https://github.com/edkolev/tmuxline.vim)
  plugin. Uninstall it and see if things work.

<hr />

> "failed to connect to server" error when sourcing .tmux.conf

Related: [issue #48](https://github.com/tmux-plugins/tpm/issues/48)

- Make sure `tmux source ~/.tmux.conf` command is ran from inside `tmux`.

<hr />

> tpm not working: '~/.tmux/plugins/tpm/tpm' returned 2 (Windows / Cygwin)

Related: [issue #81](https://github.com/tmux-plugins/tpm/issues/81)

This issue is most likely caused by Windows line endings. For example, if you
have git's `core.autocrlf` option set to `true`, git will automatically convert
all the files to Windows line endings which might cause a problem.

The solution is to convert all line ending to Unix newline characters. This
command handles that for all files under `.tmux/` dir (skips `.git`
subdirectories):

```bash
find ~/.tmux -type d -name '.git*' -prune -o -type f -print0 | xargs -0 dos2unix
```

<hr />

> '~/.tmux/plugins/tpm/tpm' returned 127 (on macOS, w/ tmux installed using brew)

Related: [issue #67](https://github.com/tmux-plugins/tpm/issues/67)

This problem is because tmux's `run-shell` command runs a shell which doesn't read from user configs, thus tmux installed in `/usr/local/bin` will not be found.

The solution is to insert the following line:

```
set-environment -g PATH "/usr/local/bin:/bin:/usr/bin"
```

before any `run-shell`/`run` commands in `~/.tmux.conf`.
