#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR/helpers"

source "$CURRENT_DIR/shared_functions.sh"

if [ "$1" == "--tmux-echo" ]; then # tmux-specific echo functions
	source "$HELPERS_DIR/tmux_echo_functions.sh"
else # shell output functions
	source "$HELPERS_DIR/shell_echo_functions.sh"
fi

clone() {
	local plugin="$1"
	cd "$SHARED_TPM_PATH" &&
		GIT_TERMINAL_PROMPT=0 git clone --recursive "$plugin" >/dev/null 2>&1
}

# tries cloning:
# 1. plugin name directly - works if it's a valid git url
# 2. expands the plugin name to point to a github repo and tries cloning again
clone_plugin() {
	local plugin="$1"
	clone "$plugin" ||
		clone "https://git::@github.com/$plugin"
}

# clone plugin and produce output
install_plugin() {
	local plugin="$1"
	local plugin_name="$(shared_plugin_name "$plugin")"

	if plugin_already_installed "$plugin"; then
		echo_ok "Already installed \"$plugin_name\""
	else
		echo_ok "Installing \"$plugin_name\""
		clone_plugin "$plugin" &&
			echo_ok "  \"$plugin_name\" download success" ||
			echo_err "  \"$plugin_name\" download fail"
	fi
}

install_plugins() {
	local plugins="$(shared_get_tpm_plugins_list)"
	for plugin in $plugins; do
		install_plugin "$plugin"
	done
}

verify_tpm_path_permissions() {
	# check the write permission flag for all users to ensure
	# that we have proper access
	[ -w "$SHARED_TPM_PATH" ] ||
		echo_err "$SHARED_TPM_PATH is not writable!"
}

main() {
	shared_set_tpm_path_constant
	ensure_tpm_path_exists
	verify_tpm_path_permissions
	install_plugins
	exit_value_helper
}
main
