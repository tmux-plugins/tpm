#!/usr/bin/env bash

# this script handles core logic of updating plugins

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR/helpers"

source "$HELPERS_DIR/plugin_functions.sh"
source "$HELPERS_DIR/utility.sh"

if [ "$1" == "--tmux-echo" ]; then # tmux-specific echo functions
	source "$HELPERS_DIR/tmux_echo_functions.sh"
else # shell output functions
	source "$HELPERS_DIR/shell_echo_functions.sh"
fi

# from now on ignore first script argument
shift

pull_changes() {
	local plugin="$1"
	local plugin_path="$(plugin_path_helper "$plugin")"
	cd "$plugin_path" &&
		GIT_TERMINAL_PROMPT=0 git pull &&
		GIT_TERMINAL_PROMPT=0 git submodule update --init --recursive
}

update() {
	local plugin="$1" output
	output=$(pull_changes "$plugin" 2>&1)
	if (( $? == 0 )); then
		echo_ok "  \"$plugin\" update success"
		echo_ok "$(echo "$output" | sed -e 's/^/    | /')"
	else
		echo_err "  \"$plugin\" update fail"
		echo_err "$(echo "$output" | sed -e 's/^/    | /')"
	fi
}

update_all() {
	echo_ok "Updating all plugins!"
	echo_ok ""
	local plugins="$(tpm_plugins_list_helper)"
	for plugin in $plugins; do
		IFS='#' read -ra plugin <<< "$plugin"
		local plugin_name="$(plugin_name_helper "${plugin[0]}")"
		# updating only installed plugins
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name" &
		fi
	done
	wait
}

update_plugins() {
	local plugins="$*"
	for plugin in $plugins; do
		IFS='#' read -ra plugin <<< "$plugin"
		local plugin_name="$(plugin_name_helper "${plugin[0]}")"
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name" &
		else
			echo_err "$plugin_name not installed!" &
		fi
	done
	wait
}

main() {
	ensure_tpm_path_exists
	if [ "$1" == "all" ]; then
		update_all
	else
		update_plugins "$*"
	fi
	exit_value_helper
}
main "$*"
