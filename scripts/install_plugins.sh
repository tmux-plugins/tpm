#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

# TMUX messaging is weird. You only get a nice clean pane if you do it with
# `run-shell` command.
echo_message() {
	local message=$1
	tmux run-shell "echo '$message'"
}

end_message() {
	echo_message ""
	echo_message "TMUX environment reloaded."
	echo_message ""
	echo_message "Done, press ENTER to continue."
}

clone() {
	local plugin=$1
	cd $SHARED_TPM_PATH &&
		git clone --recursive $plugin
}

# tries cloning:
# 1. plugin name directly - works if it's a valid git url
# 2. expands the plugin name to point to a github repo and tries cloning again
clone_plugin() {
	local plugin=$1
	clone "$plugin" ||
		clone "https://github.com/$plugin"
}

plugin_already_cloned() {
	local plugin=$1
	local plugin_path=$(shared_plugin_path "$plugin")
	cd $plugin_path &&
		git remote
}

pull_changes() {
	local plugin=$1
	local plugin_path=$(shared_plugin_path "$plugin")
	cd $plugin_path &&
		git pull &&
		git submodule update --init --recursive
}

# pull new changes or clone plugin
install_plugin() {
	local plugin=$1
	if plugin_already_cloned "$plugin"; then
		# plugin is already installed
		echo_message "Already installed $plugin"
	else
		# plugin wasn't cloned so far - clone it
		echo_message "Installing $plugin"
		clone_plugin "$plugin" &&
			echo_message "  $plugin download success" ||
			echo_message "  $plugin download fail"
	fi
}

install_plugins() {
	local plugins=$(shared_get_tpm_plugins_list)
	for plugin in $plugins; do
		install_plugin "$plugin"
	done
}

ensure_tpm_path_exists() {
	mkdir -p $SHARED_TPM_PATH
}

reload_tmux_environment() {
	tmux source-file ~/.tmux.conf >/dev/null 2>&1
}

main() {
	reload_tmux_environment
	shared_set_tpm_path_constant
	ensure_tpm_path_exists
	install_plugins
	reload_tmux_environment
	end_message
}
main
