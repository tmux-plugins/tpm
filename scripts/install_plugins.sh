#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

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

# pull new changes or clone plugin
install_plugin() {
	local plugin="$1"
	local plugin_name="$(shared_plugin_name "$plugin")"

	if plugin_already_installed "$plugin"; then
		# plugin is already installed
		echo_message "Already installed \"$plugin_name\""
	else
		# plugin wasn't cloned so far - clone it
		echo_message "Installing \"$plugin_name\""
		clone_plugin "$plugin" &&
			echo_message "  \"$plugin_name\" download success" ||
			echo_message "  \"$plugin_name\" download fail"
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
