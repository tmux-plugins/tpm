#!/usr/bin/env bash

# this script handles core logic of updating plugins

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR/helpers"

source "$HELPERS_DIR/plugin_functions.sh"
source "$HELPERS_DIR/utility.sh"

if [ "$1" == "--tmux-echo" ]; then # tmux-specific echo functions
	source "$HELPERS_DIR/tmux_echo_functions.sh"
else # shell output functions
	source "$HELPERS_DIR/shell_echo_functions.sh"
fi

# from now on ignore first script argument
shift

is_branch() {
  git show-ref --quiet --branches "$1" 2> /dev/null
  case "$?" in
    129) git show-ref --quiet --heads "$1" 2> /dev/null ;;
    *) return "$?" ;;
  esac
}

pull_changes() {
	local plugin="$1"
	local plugin_path="$(plugin_path_helper "$plugin")"
	(
		set -e

		cd "$plugin_path"
		export GIT_TERMINAL_PROMPT=0

		local branch="${2:-"$(LC_ALL=en_US git remote show origin | sed -n '/HEAD branch/s/.*: //p')"}"
		# Since `clone()` in *install_plugins.sh* uses `--single-branch`, the
		# `remote.origin.fetch` is set to `+refs/tags/<BRANCH>:refs/tags/<BRANCH>`.
		# Thus, no other branch could be used, but only the one that was used
		# during the `clone()`.
		#
		# The following `git config` allows to use other branches that are
		# available on remote.
		git config --replace-all remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
		# Fetch recent branches/tags/commits.
		# `--tags` ensures that tags from the remote are fetched.
		# `--force` ensures that updated tags do not cause errors during fetch.
		git fetch --force --tags
		# `checkout` should be used after `fetch`.
		git checkout "$branch"
		# `merge` can only be used when HEAD points to a branch.
		if is_branch "$branch"
		then
			git merge --ff-only
		fi

		git submodule update --init --recursive
	)
}

update() {
	local plugin="$1" output
	local branch="$2"
	output=$(pull_changes "$plugin" "$branch" 2>&1)
	if (( $? == 0 )); then
		echo_ok "  \"$plugin\" update success"
		echo_ok "$(echo "$output" | sed -e 's/^/    | /')"
	else
		echo_err "  \"$plugin\" update fail"
		echo_err "$(echo "$output" | sed -e 's/^/    | /')"
	fi
}

update_all() {
	echo_ok "Updating all plugins!"
	echo_ok ""
	local plugins="$(tpm_plugins_list_helper)"
	for plugin in $plugins; do
		IFS='#' read -ra plugin <<< "$plugin"
		local plugin_name="$(plugin_name_helper "${plugin[0]}")"
		local branch="${plugin[1]}"
		# updating only installed plugins
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name" "$branch" &
		fi
	done
	wait
}

update_plugins() {
	local plugins="$*"
	for plugin in $plugins; do
		IFS='#' read -ra plugin <<< "$plugin"
		local plugin_name="$(plugin_name_helper "${plugin[0]}")"
		local branch="${plugin[1]}"
		if plugin_already_installed "$plugin_name"; then
			update "$plugin_name" "$branch" &
		else
			echo_err "$plugin_name not installed!" &
		fi
	done
	wait
}

main() {
	ensure_tpm_path_exists
	if [ "$1" == "all" ]; then
		update_all
	else
		update_plugins "$*"
	fi
	exit_value_helper
}
main "$*"
