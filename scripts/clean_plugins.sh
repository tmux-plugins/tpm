#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR/helpers"

source "$CURRENT_DIR/shared_functions.sh"

if [ "$1" == "--tmux-echo" ]; then # tmux-specific echo functions
	source "$HELPERS_DIR/tmux_echo_functions.sh"
else # shell output functions
	source "$HELPERS_DIR/shell_echo_functions.sh"
fi

clean_plugins() {
	local plugins plugin plugin_directory
	plugins="$(shared_get_tpm_plugins_list)"

	for plugin_directory in "$(tpm_path)"/*; do
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
	ensure_tpm_path_exists
	clean_plugins
	exit_value_helper
}
main
