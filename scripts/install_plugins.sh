#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

clone() {
	local plugin; plugin="$1"
	cd "$SHARED_TPM_PATH" &&
		GIT_TERMINAL_PROMPT=0 git clone --recursive $plugin
}

install_plugin_git() {
	local plugin; plugin="$1"
	local branch; branch=":${1##*:}"
	plugin="${1%$branch}"
	clone "$plugin" ||
		 clone "git:$plugin"
	if [ "${branch}" != ":${1}" ]; then #if exists branch/revision
		(cd "$SHARED_TPM_PATH"/$(shared_plugin_name "$plugin") &&
		git checkout -q "${branch#:}" 2>&1 >/dev/null)
	fi
}

# tries cloning:
# 1. plugin name directly - works if it's a valid git url
# 2. expands the plugin name to point to a github repo and tries cloning again
install_plugin_github() {
	local plugin; plugin="$1"
	local branch; branch=":${1##*:}"
	plugin="${1%$branch}"
	clone "$plugin" ||
		clone "https://git::@github.com/$plugin"
	if [ "${branch}" != ":${1}" ]; then #if exists branch/revision
		(cd "$SHARED_TPM_PATH"/$(shared_plugin_name "$plugin") &&
		git checkout -q "${branch#:}" 2>&1 >/dev/null)
	fi
}

install_plugin_web() {
	local plugin; plugin="$1"
	local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"
	(cd "$SHARED_TPM_PATH" && mkdir "${plugin_name}" &&
	cd "${plugin_name}" && (wget --no-check-certificate "${plugin}" ||
	curl -k -s -O "${plugin}"))
}

install_plugin_local() {
	local plugin; plugin="$1"
	local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"
	(cd "$SHARED_TPM_PATH" && mkdir "${plugin_name}" &&
	cd "${plugin_name}" && cp -r "${plugin}" .)
}

# pull new changes or clone plugin
install_plugin() {
	local plugin; plugin="$1"
	local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"

	if plugin_already_installed "$plugin"; then
		# plugin is already installed
		echo_message "Already installed \"$plugin_name\""
	else
		echo_message "Installing \"$plugin_name\""
		local handler; handler="${1%%:*}:"
		plugin="${1#$handler}"

		case "${handler}" in
			''|*/*) case "${1}" in
					/*|~*|\$*)	install_plugin_local  "${1}" ;;
					*)		install_plugin_github "${1}" ;;
				esac ;;
			gh*|github*|git@github.com*)	install_plugin_github "${plugin}" ;;
			git:)				install_plugin_git "${plugin}" ;;
			file:)				install_plugin_local "${plugin#//}" ;;
			http:|ftp:)			install_plugin_web "${1}" ;;
			https:)
				case "${1}" in
					*github.com/*) install_plugin_github "${plugin#//github.com/}";;
					*) install_plugin_web "${1}";;
				esac ;;
			*) set_false ;;
		 esac

		 [ X"${?}" = X"0" ] &&
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
