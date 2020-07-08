# using @tpm_plugins is now deprecated in favor of using @plugin syntax
tpm_plugins_variable_name="@tpm_plugins"

# Get the absolute path to the users configuration file of TMux.
# This includes a prioritized search on different locations.
#
_get_user_tmux_conf() {
	# Define the different possible locations.
	xdg_location="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
	default_location="$HOME/.tmux.conf"

	# Search for the correct configuration file by priority.
	if [ -f "$xdg_location" ]; then
		echo "$xdg_location"

	else
		echo "$default_location"
	fi
}

_exec_tmux() {
	local OPTS=()
	if [[ -z "$TMUX" ]]; then
		OPTS+=(-f "$(_get_user_tmux_conf)" start-server \;)
	fi

	tmux "${OPTS[@]}" "${@}"
}

# manually expanding tilde char or `$HOME` variable.
_manual_expansion() {
	local path="$1"
	local expanded_tilde="${path/#\~/$HOME}"
	echo "${expanded_tilde/#\$HOME/$HOME}"
}

_tpm_path() {
	local string_path="$(_exec_tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)/"
	_manual_expansion "$string_path"
}

_CACHED_TPM_PATH="$(_tpm_path)"

# Want to be able to abort in certain cases
trap "exit 1" TERM
export TOP_PID=$$

_fatal_error_abort() {
	echo >&2 "Aborting."
	kill -s TERM $TOP_PID
}

# PUBLIC FUNCTIONS BELOW

tpm_path() {
	if [ "$_CACHED_TPM_PATH" == "/" ]; then
		echo >&2 "FATAL: Tmux Plugin Manager not configured in tmux.conf"
		_fatal_error_abort
	fi
	echo "$_CACHED_TPM_PATH"
}

tpm_plugins_list_helper() {
	# lists plugins from @tpm_plugins option and @plugins
	_exec_tmux show-option -gqv "$tpm_plugins_variable_name" \; \
	           show-option -gqv "@plugin" \;
}

# Allowed plugin name formats:
# 1. "git://github.com/user/plugin_name.git"
# 2. "user/plugin_name"
plugin_name_helper() {
	local plugin="$1"
	# get only the part after the last slash, e.g. "plugin_name.git"
	local plugin_basename="$(basename "$plugin")"
	# remove ".git" extension (if it exists) to get only "plugin_name"
	local plugin_name="${plugin_basename%.git}"
	echo "$plugin_name"
}

plugin_path_helper() {
	local plugin="$1"
	local plugin_name="$(plugin_name_helper "$plugin")"
	echo "$(tpm_path)${plugin_name}/"
}

plugin_already_installed() {
	local plugin="$1"
	local plugin_path="$(plugin_path_helper "$plugin")"
	[ -d "$plugin_path" ] &&
		cd "$plugin_path" &&
		git remote >/dev/null 2>&1
}
