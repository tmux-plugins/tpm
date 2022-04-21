ensure_tpm_path_exists() {
	mkdir -p "$(tpm_path)"
}

fail_helper() {
	local message="$1"
	echo "$message" >&2
	FAIL="true"
}

exit_value_helper() {
	if [ "$FAIL" == "true" ]; then
		exit 1
	else
		exit 0
	fi
}

set_long_tmux_display_time() {
	#
	#  Since tmux display is used to indicate progress, save original
	#  display-time and temporarily set it to 2 minutes.
	#  New messages will overwrite previous, so this is not blocking anything.
	#  It is just a random long time to ensure that the messages don't time-out.
	#
	#  Use this to restore the original display-time before exiting:
	#
	#   tmux set-option -g display-time "$org_display_time"
	#
	org_display_time="$(tmux show-options -g display-time | awk '{print $2}')"
	tmux set-option -g display-time 120000
}
