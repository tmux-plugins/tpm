# using @tpm_plugins is now deprecated in favor of using @plugin syntax
tpm_plugins_variable_name="@tpm_plugins"

# manually expanding tilde char or `$HOME` variable.
_manual_expansion() {
	local path="$1"
	local expanded_tilde="${path/#\~/$HOME}"
	echo "${expanded_tilde/#\$HOME/$HOME}"
}

_tpm_path() {
	local string_path="$(tmux start-server\; show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)/"
	_manual_expansion "$string_path"
}

_CACHED_TPM_PATH="$(_tpm_path)"

_tmux_conf_contents() {
	cat /etc/tmux.conf ~/.tmux.conf 2>/dev/null
	if [ "$1" == "full" ]; then # also output content from sourced files
		local file
		for file in $(_sourced_files); do
			cat $(_manual_expansion "$file") 2>/dev/null
		done
	fi
}

# return files sourced from tmux config files
_sourced_files() {
	_tmux_conf_contents |
		awk '/^ *source(-file)? +/ { gsub(/'\''/,""); gsub(/'\"'/,""); print $2 }'
}

# PUBLIC FUNCTIONS BELOW

tpm_path() {
	echo "$_CACHED_TPM_PATH"
}

tpm_plugins_list_helper() {
	# DEPRECATED: lists plugins from @tpm_plugins option
	echo "$(tmux start-server\; show-option -gqv "$tpm_plugins_variable_name")"

	# read set -g @plugin "tmux-plugins/tmux-example-plugin" entries
	_tmux_conf_contents "full" |
		awk '/^ *set(-option)? +-g +@plugin/ { gsub(/'\''/,""); gsub(/'\"'/,""); print $4 }'
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
