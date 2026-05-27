CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/../variables.sh"

tpm_path_set() {
	tmux show-environment -g "$DEFAULT_TPM_ENV_VAR_NAME" >/dev/null 2>&1
}

# Check if configuration file exists at an XDG-compatible location, if so use
# that directory for TMUX_PLUGIN_MANAGER_PATH. Otherwise use $DEFAULT_TPM_PATH.
set_default_tpm_path() {
	local xdg_tmux_path="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
	local tpm_path="$DEFAULT_TPM_PATH"

	if [ -f "$xdg_tmux_path/tmux.conf" ]; then
		tpm_path="$xdg_tmux_path/plugins/"
	fi

	tmux set-environment -g "$DEFAULT_TPM_ENV_VAR_NAME" "$tpm_path"
}

# Ensures TMUX_PLUGIN_MANAGER_PATH global env variable is set.
#
# Put this in `.tmux.conf` to override the default:
# `set-environment -g TMUX_PLUGIN_MANAGER_PATH "/some/other/path/"`
set_tpm_path() {
	if ! tpm_path_set; then
		set_default_tpm_path
	fi
}
