#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

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
			echo_message "Removing \"$plugin\""
			rm -rf "${plugin_directory}"
			[ -d "${plugin_directory}" ] &&
			echo_message "  \"$plugin\" clean fail" ||
			echo_message "  \"$plugin\" clean success"
			;;
		esac
	done
}

main() {
	reload_tmux_environment
	shared_set_tpm_path_constant
	ensure_tpm_path_exists
	clean_plugins
	reload_tmux_environment
	end_message
}
main
