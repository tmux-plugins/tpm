# shared functions and constants

tpm_plugins_variable_name="@tpm_plugins"
SHARED_TPM_PATH=""

# sets a "global variable" for the current file
shared_set_tpm_path_constant() {
	#local string_path="$(tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
	#pipes(due to fork) are expensive, the less the better
	local string_path="$(tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH)"; string_path="${string_path##*=}"
	# NOTE: manually expanding tilde or `$HOME` variable. Avoids using `eval` as
	# described here http://stackoverflow.com/a/5748307/777337
	SHARED_TPM_PATH="$(echo "$string_path" | sed "s,^\$HOME,$HOME,;s,^~,$HOME,;")"
}

shared_get_tpm_plugins_list() {
	local plugins_list
	plugins_list="$(tmux show-option -gqv "$tpm_plugins_variable_name")"
	if [ -z "${plugins_list}" ]; then
		cat /etc/tmux.conf ~/.tmux.conf 2>/dev/null | \
		#read set -g @bundle "tmux-plugins/tmux-example-plugin" entries
		awk '/set.*-g.*@[bB][uU][nN][dD][lL][eE]/ {if($1!~"^#"){gsub(/'\''/,"");gsub(/'\"'/,"");print $4}}' #recover vim syntax'
	else
		printf "%s\\n" "${plugins_list}"
	fi
}

# Allowed plugin name formats:
# 1.  "user/plugin_name"
# 2.  "user/plugin_name:branch"
# 3.  "gh:user/plugin_name"
# 4.  "gh:user/plugin_name:branch"
# 5.  "github:user/plugin_name"
# 6.  "github:user/plugin_name:branch"
# 7.  "http://github.com/user/plugin_name"
# 8.  "https://github.com/user/plugin_name:branch"
# 9.  "git://github.com/user/plugin_name.git"
# 10. "git://github.com/user/plugin_name.git:branch"
# 11. "git://domain.tld/plugin_name"
# 12. "git://domain.tld/plugin_name:branch"
# 13. "http://domain.tld/plugin_name"
# 14. "https://domain.tld/plugin_name"
# 15. "ftp://domain.tld/plugin_name"
# 16. "file://local/path/plugin_name"
shared_plugin_name() {
	local plugin; plugin="$1"
	# get only the part after the last slash, e.g. "plugin_name.git:branch"
	local plugin_basename; plugin_basename="$(basename "$plugin")"
	# remove branch (if it exists) to get only "plugin_name.git"
	local plugin_name; plugin_name="${plugin_basename%:*}"
	# remove ".git" extension (if it exists) to get only "plugin_name"
	plugin_name="${plugin_name%.git}"
	echo "$plugin_name"
}

shared_plugin_path() {
	local plugin=$1
	local plugin_name=$(shared_plugin_name "$plugin")
	echo "$SHARED_TPM_PATH$plugin_name/"
}

# TMUX messaging is weird. You only get a nice clean pane if you do it with
# `run-shell` command.
echo_message() {
	local message="$1"
	tmux run-shell "echo '$message'"
}

reload_tmux_environment() {
	tmux source-file ~/.tmux.conf >/dev/null 2>&1
}

plugin_already_installed() {
	local plugin="$1"
	local plugin_path="$(shared_plugin_path "$plugin")"
	cd "$plugin_path" #&& unmarry from git
		#git remote >/dev/null 2>&1
}

end_message() {
	echo_message ""
	echo_message "TMUX environment reloaded."
	echo_message ""
	echo_message "Done, press ENTER to continue."
}

set_false()
{
	return 1
}

# Ensures a message is displayed for 5 seconds in tmux prompt.
# Does not override the 'display-time' tmux option.
display_message() {
	local message="$1"

	# display_duration defaults to 5 seconds, if not passed as an argument
	if [ "$#" -eq 2 ]; then
		local display_duration="$2"
	else
		local display_duration="5000"
	fi

	# saves user-set 'display-time' option
	local saved_display_time=$(get_tmux_option "display-time" "750")

	# sets message display time to 5 seconds
	tmux set-option -gq display-time "$display_duration"

	# displays message
	tmux display-message "$message"

	# restores original 'display-time' value
	tmux set-option -gq display-time "$saved_display_time"
}
