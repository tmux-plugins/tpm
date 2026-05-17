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
	local branch="$2"
	local alias="$3"
  cd "$(tpm_path)" && {
    local git_cmd=(git clone --single-branch --recursive)
    [ -n "$branch" ] && git_cmd+=(-b "$branch")
    git_cmd+=("$plugin" ${alias:+"$alias"})

    GIT_TERMINAL_PROMPT=0 "${git_cmd[@]}" >/dev/null 2>&1
  }
}

# tries cloning:
# 1. plugin name directly - works if it's a valid git url
# 2. expands the plugin name to point to a GitHub repo and tries cloning again
clone_plugin() {
	local plugin="$1"
	local branch="$2"
	local alias="$3"
	clone "$plugin" "$branch" "$alias" ||
		clone "https://git::@github.com/$plugin" "$branch" "$alias"
}

# clone plugin and produce output
install_plugin() {
	local plugin="${1%%;*}"
	local alias=$(echo $1$2 | sed -E 's/.*alias[[:space:]]*[:=][[:space:]]*//')
	local branch="${2%%;*}"
	local plugin_name="$(plugin_name_helper "$plugin")"

  [[ "$alias" == "$1$2" ]] && alias=""

	if plugin_already_installed "$plugin"; then
		echo_ok "Already installed \"$plugin_name\""
	else
		echo_ok "Installing \"$plugin_name\""
		clone_plugin "$plugin" "$branch" "$alias" &&
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
