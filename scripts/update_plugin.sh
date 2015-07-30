#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

empty() {
	[ -z "$1" ]
}

if_all() {
	[ "$1" == "all" ]
}

cancel() {
	exit 0
}

update_plugin_git() {
	local plugin; plugin="$1"
	local branch; branch=":${1##*:}"
	local plugin_path; plugin_path=$(shared_plugin_path "$plugin")
	plugin="${1%$branch}"
	#update only makes sense when no specific branch/revision is set
	if [ "${branch}" = ":${1}" ]; then
		 cd "$plugin_path" &&
			  GIT_TERMINAL_PROMPT="0" git pull &&
			  GIT_TERMINAL_PROMPT="0" git submodule update --init --recursive
	fi
}

update_plugin_web() {
	local plugin; plugin="$1"
	local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"
	local plugin_path; plugin_path=$(shared_plugin_path "$plugin")
	(cd "$plugin_path" && rm -rf "${plugin_name}" &&
	(wget --no-check-certificate "${plugin}" || curl -k -s -O "${plugin}"))
}

update_plugin_local() {
	local plugin; plugin="$1"
	local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"
	local plugin_path; plugin_path=$(shared_plugin_path "$plugin")
	cd "$plugin_path" && rm -rf "${plugin_name}" && cp -r "${plugin}" .
}

update() {
	local plugin; plugin="$1"
	local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"
	echo_message "Updating \"$plugin_name\""

	local handler; handler="${1%%:*}:"
	plugin="${1#$handler}"

	case "${handler}" in
		''|*/*) case "${1}" in
			/*|~*|\$*)	update_plugin_local "${1}" ;;
			*)		update_plugin_git   "${1}" ;;
			esac ;;
		gh*|github*|git@github.com*)	update_plugin_git   "${plugin}" ;;
		git:)				update_plugin_git   "${plugin}" ;;
		file:)				update_plugin_local "${plugin#//}" ;;
		http:|ftp:)			update_plugin_web   "${1}" ;;
		https:)
			case "${1}" in
				*github.com/*) update_plugin_git "${plugin#//github.com/}";;
				*) update_plugin_web "${1}";;
			esac ;;
		*) set_false ;;
	esac

	[ "${?}" = "0" ] &&
		 echo_message "  \"$plugin_name\" update success" ||
		 echo_message "  \"$plugin_name\" update fail"
}


update_all() {
	local plugins plugin; plugins="$(shared_get_tpm_plugins_list)"
	for plugin in $plugins; do
		local plugin_name; plugin_name="$(shared_plugin_name "$plugin")"
		# updating only installed plugins
		if plugin_already_installed "$plugin_name"; then
			update "$plugin"
		fi
	done
}

handle_plugin_update() {
	local arg; arg="$1"

	if empty "$arg"; then
		cancel

	elif if_all "$arg"; then
		echo_message "Updating all plugins!"
		echo_message ""
		update_all

	elif plugin_already_installed "$arg"; then
		update "$arg"

	else
		display_message "It seems this plugin is not installed: $arg"
		cancel
	fi
}

main() {
	local arg; arg="$1"
	shared_set_tpm_path_constant
	handle_plugin_update "$arg"
	reload_tmux_environment
	end_message
}
main "$1"
