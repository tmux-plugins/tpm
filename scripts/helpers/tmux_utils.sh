reload_tmux_environment() {
	tmux source-file ~/.tmux.conf >/dev/null 2>&1
}
