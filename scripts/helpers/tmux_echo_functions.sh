_has_emacs_mode_keys() {
	$(tmux show -gw mode-keys | grep -q emacs)
}

tmux_echo() {
	local message="$1"
	tmux display-message "$message"
	tmux run-shell "echo '$message'"
}

echo_ok() {
	tmux_echo "$*"
}

echo_err() {
	tmux_echo "$*"
	sleep 3  #  Give some time for error message to be displayed in status bar
}

end_message() {
	if _has_emacs_mode_keys; then
		local continue_key="ESCAPE"
	else
		local continue_key="ENTER"
	fi
	tmux_echo ""
	tmux_echo "TMUX environment reloaded."
	tmux_echo ""
	tmux_echo "Done, press $continue_key to continue."
}
