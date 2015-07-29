#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

TMUX_ECHO_FLAG="$1"

# True if invoked as tmux mapping or tmux command,
# false if invoked via command line wrapper from `bin/` directory.
use_tmux_echo() {
	[ "$TMUX_ECHO_FLAG" == "--tmux-echo" ]
}

if use_tmux_echo; then
	# use tmux specific echo-ing
	echo_ok() {
		echo_message "$*"
	}

	echo_err() {
		echo_message "$*"
	}
else
	echo_ok() {
		echo "$*"
	}

	echo_err() {
		fail_helper "$*"
	}
fi

clone() {
	local plugin="$1"
	cd "$SHARED_TPM_PATH" &&
		GIT_TERMINAL_PROMPT=0 git clone --recursive $plugin
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
	local plugins=$(shared_get_tpm_plugins_list)
	for plugin in $plugins; do
		install_plugin "$plugin"
	done
}

verify_tpm_path_permissions() {
	# check the write permission flag for all users to ensure
	# that we have proper access
	[ -w $SHARED_TPM_PATH ] || echo_message "$SHARED_TPM_PATH does not seem to be writable!"
}

main() {
	shared_set_tpm_path_constant
	ensure_tpm_path_exists
	verify_tpm_path_permissions
	install_plugins
	exit_value_helper
}
main
