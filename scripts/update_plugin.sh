#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

empty() {
	[ -z "$1" ]
}

if_all() {
	[ "$1" == "all" ]
}

cancel() {
	exit 0
}

pull_changes() {
	local plugin="$1"
	local plugin_path=$(shared_plugin_path "$plugin")
	cd $plugin_path &&
		git pull &&
		git submodule update --init --recursive
}

update() {
	local plugin="$1"
	echo_message "Updating \"$plugin\""
	$(pull_changes "$plugin" > /dev/null 2>&1) &&
		echo_message "  \"$plugin\" update success" ||
		echo_message "  \"$plugin\" update fail"
}


update_all() {
	local plugins="$(shared_get_tpm_plugins_list)"
	for plugin in $plugins; do
		local plugin_name="$(shared_plugin_name "$plugin")"
		# updating only installed plugins
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name"
		fi
	done
}

handle_plugin_update() {
	local arg="$1"

	if empty "$arg"; then
		cancel

	elif if_all "$arg"; then
		echo_message "Updating all plugins!"
		echo_message ""
		update_all

	elif plugin_already_installed "$arg"; then
		update "$arg"

	else
		display_message "It seems this plugin is not installed: $arg"
		cancel
	fi
}

main() {
	local arg="$1"
	shared_set_tpm_path_constant
	handle_plugin_update "$arg"
	reload_tmux_environment
	end_message
}
main "$1"
