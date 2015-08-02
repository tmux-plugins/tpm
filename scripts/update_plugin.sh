#!/usr/bin/env bash

# this script handles core logic of updating plugins

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

TMUX_ECHO_FLAG="$1"
shift

# True if invoked as tmux mapping or tmux command,
# false if invoked via command line wrapper from `bin/` directory.
use_tmux_echo() {
	[ "$TMUX_ECHO_FLAG" == "--tmux-echo" ]
}

if use_tmux_echo; then
	# use tmux specific echo-ing
	echo_ok() {
		tmux_echo "$*"
	}

	echo_err() {
		tmux_echo "$*"
	}
else
	echo_ok() {
		echo "$*"
	}

	echo_err() {
		fail_helper "$*"
	}
fi

pull_changes() {
	local plugin="$1"
	local plugin_path="$(shared_plugin_path "$plugin")"
	cd "$plugin_path" &&
		GIT_TERMINAL_PROMPT=0 git pull &&
		GIT_TERMINAL_PROMPT=0 git submodule update --init --recursive
}

update() {
	local plugin="$1"
	echo_ok "Updating \"$plugin\""
	$(pull_changes "$plugin" > /dev/null 2>&1) &&
		echo_ok "  \"$plugin\" update success" ||
		echo_err "  \"$plugin\" update fail"
}

update_all() {
	echo_ok "Updating all plugins!"
	echo_ok ""
	local plugins="$(shared_get_tpm_plugins_list)"
	for plugin in $plugins; do
		local plugin_name="$(shared_plugin_name "$plugin")"
		# updating only installed plugins
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name"
		fi
	done
}

update_plugins() {
	local plugins="$*"
	for plugin in $plugins; do
		local plugin_name="$(shared_plugin_name "$plugin")"
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name"
		else
			echo_err "$plugin_name not installed!"
		fi
	done
}

main() {
	shared_set_tpm_path_constant
	if [ "$1" == "all" ]; then
		update_all
	else
		update_plugins "$*"
	fi
	exit_value_helper
}
main "$*"
