reload_tmux_environment() {
	tmux source-file $(_get_user_tmux_conf) >/dev/null 2>&1
}
