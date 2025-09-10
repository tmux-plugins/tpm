#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR/helpers"

source "$HELPERS_DIR/plugin_functions.sh"
source "$HELPERS_DIR/utility.sh"

if [ "$1" == "--tmux-echo" ]; then # tmux-specific echo functions
	source "$HELPERS_DIR/tmux_echo_functions.sh"
else # shell output functions
	source "$HELPERS_DIR/shell_echo_functions.sh"
fi

clone() {
	local plugin="$1"
	local ref="$2"
	local clone_options=""
	
	# Handle both branches and tags
	if [[ -n "$ref" ]]; then
		clone_options="--branch $ref"
	fi
	
	local plugin_name="$(plugin_name_helper "$plugin")"
	local plugin_dir="$(tpm_path)${plugin_name}/"
	
	# Create the user directory if it doesn't exist
	mkdir -p "$(dirname "$plugin_dir")"
	
	if [[ ! $plugin == *"https://"* ]] && [[ ! $plugin == *"git@"* ]]; then
		cd "$(tpm_path)" &&
			GIT_TERMINAL_PROMPT=0 git clone $clone_options --single-branch --recursive "https://git::@github.com/$plugin" "$plugin_name" >/dev/null 2>&1
	else
		cd "$(tpm_path)" &&
			GIT_TERMINAL_PROMPT=0 git clone $clone_options --single-branch --recursive "$plugin" "$plugin_name" >/dev/null 2>&1
	fi
}

clone_plugin() {
	local plugin="$1"
	local branch="$2"
	clone "$plugin" "$branch" ||
		clone "https://git::@github.com/$plugin" "$branch"
}

# clone plugin and produce output
install_plugin() {
	local plugin="$1"
	local branch="$2"
	local plugin_name="$(plugin_name_helper "$plugin")"

	if plugin_already_installed "$plugin"; then
		echo_ok "Already installed \"$plugin_name\""
	else
		echo_ok "Installing \"$plugin_name\""
		clone_plugin "$plugin" "$branch" &&
			echo_ok "  \"$plugin_name\" download success" ||
			echo_err "  \"$plugin_name\" download fail"
	fi
}

install_plugins() {
	local plugins="$(tpm_plugins_list_helper)"
	for plugin in $plugins; do
		IFS='#' read -ra plugin <<< "$plugin"
		install_plugin "${plugin[0]}" "${plugin[1]}"
	done
}

verify_tpm_path_permissions() {
	local path="$(tpm_path)"
	# check the write permission flag for all users to ensure
	# that we have proper access
	[ -w "$path" ] ||
		echo_err "$path is not writable!"
}

main() {
	ensure_tpm_path_exists
	verify_tpm_path_permissions
	install_plugins
	exit_value_helper
}
main
