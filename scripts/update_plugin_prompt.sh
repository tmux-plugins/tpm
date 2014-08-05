#!/usr/bin/env bash

# when invoked with `prefix + U` this script:
# - shows a list of installed plugins
# - starts a prompt to enter the name of the plugin that will be updated

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

display_plugin_update_list() {
	local plugins="$(shared_get_tpm_plugins_list)"
	echo_message "Installed plugins:"
	echo_message ""

	for plugin in $plugins; do
		# displaying only installed plugins
		if plugin_already_installed "$plugin"; then
			local plugin_name="$(shared_plugin_name "$plugin")"
			echo_message "  $plugin_name"
		fi
	done

	echo_message ""
	echo_message "Type plugin name to update it."
	echo_message ""
	echo_message "- \"all\" - updates all plugins"
	echo_message "- ENTER - cancels"
}

update_plugin_prompt() {
	tmux command-prompt -p 'plugin update:' " \
		send-keys C-m; \
		run-shell '$CURRENT_DIR/update_plugin.sh %1'"
}


main() {
	reload_tmux_environment
	shared_set_tpm_path_constant
	display_plugin_update_list
	update_plugin_prompt
}
main
