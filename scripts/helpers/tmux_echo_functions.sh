tmux_echo() {
	local message="$1"
	tmux run-shell "echo '$message'"
}

echo_ok() {
	tmux_echo "$*"
}

echo_err() {
	tmux_echo "$*"
}

end_message() {
	tmux_echo ""
	tmux_echo "TMUX environment reloaded."
	tmux_echo ""
	tmux_echo "Done, press ENTER to continue."
}
