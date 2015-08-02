#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

TMUX_ECHO_FLAG="$1"

# True if invoked as tmux mapping or tmux command,
# false if invoked via command line wrapper from `bin/` directory.
use_tmux_echo() {
	[ "$TMUX_ECHO_FLAG" == "--tmux-echo" ]
}

if use_tmux_echo; then
	# use tmux specific echo-ing
	echo_ok() {
		echo_message "$*"
	}

	echo_err() {
		echo_message "$*"
	}
else
	echo_ok() {
		echo "$*"
	}

	echo_err() {
		fail_helper "$*"
	}
fi

clean_plugins() {
	local plugins plugin plugin_directory
	plugins="$(shared_get_tpm_plugins_list)"

	for plugin_directory in "$SHARED_TPM_PATH"/*; do
		[ -d "${plugin_directory}" ] || continue
		plugin="$(shared_plugin_name "${plugin_directory}")"
		case "${plugins}" in
			*"${plugin}"*) : ;;
			*)
			[ "${plugin}" = "tpm" ] && continue
			echo_ok "Removing \"$plugin\""
			rm -rf "${plugin_directory}" >/dev/null 2>&1
			[ -d "${plugin_directory}" ] &&
			echo_err "  \"$plugin\" clean fail" ||
			echo_ok "  \"$plugin\" clean success"
			;;
		esac
	done
}

main() {
	shared_set_tpm_path_constant
	ensure_tpm_path_exists
	clean_plugins
	exit_value_helper
}
main
