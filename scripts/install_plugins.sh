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
	[[ -z "$2" ]] && local branch="" || local branch="--branch $2"
	if [[ ! $plugin == *"https://"* ]]; then
		cd "$(tpm_path)" &&
			GIT_TERMINAL_PROMPT=0 git clone $branch --single-branch --recursive "https://git::@github.com/$plugin" $plugin >/dev/null 2>&1
	else
		local basename_with_git="$(basename "$plugin")"
		local basename="${basename_with_git%.git}"
		cd "$(tpm_path)" &&
			GIT_TERMINAL_PROMPT=0 git clone $branch --single-branch --recursive "$basename" $basename >/dev/null 2>&1
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
		if [[ "$plugin" == *#* ]]; then
			IFS='#' read -ra plugin <<< "$plugin"
			install_plugin "${plugin[0]}" "${plugin[1]}"
		elif [[ "$plugin" == *@* ]]; then
			IFS='@' read -ra plugin <<< "$plugin"
			install_plugin "${plugin[0]}" "${plugin[1]}"
		else
			install_plugin ${plugin}
		fi
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
