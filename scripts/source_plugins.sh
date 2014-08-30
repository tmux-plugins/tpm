#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

plugin_dir_exists() {
	[ -d "$1" ]
}

# Runs all *.tmux files from the plugin directory.
# Files are ran as executables.
# No errors if the plugin dir does not exist.
silently_source_all_tmux_files() {
	local plugin_path=$1
	local plugin_tmux_files="$plugin_path*.tmux"
	if plugin_dir_exists "$plugin_path"; then
		for tmux_file in $plugin_tmux_files; do
			# runs *.tmux file as an executable
			$tmux_file >/dev/null 2>&1
		done
	fi
}

source_plugin() {
	local plugin=$1
	local plugin_path=$(shared_plugin_path "$plugin")
	silently_source_all_tmux_files "$plugin_path"
}

source_plugins() {
	local plugins=$(shared_get_tpm_plugins_list)
	for plugin in $plugins; do
		source_plugin "$plugin"
	done
}

main() {
	shared_set_tpm_path_constant
	source_plugins
}
main
