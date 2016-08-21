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

print_update_status() {
	# Indent and format the output from the update command.
	local plugin="$1"
	local update_output=$(echo "$2" | awk '{print "     | "$0}')
	local update_status=$3

	if [ $update_status == "0" ]; then
		echo_ok "$update_output\n  \"$plugin\" update success"
		echo_ok
	else
		echo_err "$update_output\n  \"$plugin\" update fail"
		echo_err
	fi
}

update() {
	local plugin="$1"
	echo_ok "Updating \"$plugin\""
	# Note, this cannot be a local variable, since that seems to supress the $? from being set.
	update_output=$(pull_changes "$plugin" 2>&1);
	local update_status="$?"
	$(print_update_status "$plugin" "$update_output" "$update_status")
}

update_all() {
	echo_ok "Updating all plugins!"
	echo_ok ""
	local plugins="$(tpm_plugins_list_helper)"
	for plugin in $plugins; do
		local plugin_name="$(plugin_name_helper "$plugin")"
		# updating only installed plugins
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name"
		fi
	done
}

update_plugins() {
	local plugins="$*"
	for plugin in $plugins; do
		local plugin_name="$(plugin_name_helper "$plugin")"
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name"
		else
			echo_err "$plugin_name not installed!"
		fi
	done
}

main() {
	if [ "$1" == "all" ]; then
		update_all
	else
		update_plugins "$*"
	fi
	exit_value_helper
}
main "$*"
