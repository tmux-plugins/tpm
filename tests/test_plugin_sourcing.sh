#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TPM_DIR="$PWD"
PLUGINS_DIR="$HOME/.tmux/plugins"

CUSTOM_PLUGINS_DIR="$HOME/foo/plugins"

source "$CURRENT_DIR/helpers/helpers.sh"
source "$CURRENT_DIR/helpers/tpm.sh"

check_binding_defined() {
	local binding="$1"
	tmux list-keys | grep -q "$binding"
}

create_test_plugin_helper() {
	local plugin_path="$PLUGINS_DIR/tmux_test_plugin/"
	rm -rf "$plugin_path"
	mkdir -p "$plugin_path"

	while read line; do
		echo "$line" >> "$plugin_path/test_plugin.tmux"
	done
	chmod +x "$plugin_path/test_plugin.tmux"
}

check_tpm_path() {
	local correct_tpm_path="$1"
	local tpm_path="$(tmux start-server\; show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)"
	[ "$correct_tpm_path" == "$tpm_path" ]
}

test_plugin_sourcing() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "doesnt_matter/tmux_test_plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	# manually creates a local tmux plugin
	create_test_plugin_helper <<- HERE
	tmux bind-key R run-shell foo_command
	HERE

	tmux new-session -d  # tmux starts detached
	check_binding_defined "R run-shell foo_command" ||
		fail_helper "Plugin sourcing fails"

	teardown_helper
}

test_default_tpm_path() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	run-shell "$TPM_DIR/tpm"
	HERE

	check_tpm_path "${PLUGINS_DIR}/" ||
		fail_helper "Default TPM path not correct"

	teardown_helper
}

test_custom_tpm_path() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set-environment -g TMUX_PLUGIN_MANAGER_PATH '$CUSTOM_PLUGINS_DIR'
	run-shell "$TPM_DIR/tpm"
	HERE

	check_tpm_path "$CUSTOM_PLUGINS_DIR" ||
		fail_helper "Custom TPM path not correct"

	teardown_helper
}

test_xdg_tmux_conf_sourcing() {
	local xdg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
	local xdg_conf="${xdg_dir}/tmux.conf"
	local xdg_plugin_dir="${xdg_dir}/plugins/tmux_test_plugin"
	rm -f ~/.tmux.conf
	mkdir -p "$(dirname "$xdg_conf")" "$xdg_plugin_dir"
	cat > "$xdg_conf" <<- HERE
	set -g mode-keys vi
	set -g @plugin "doesnt_matter/tmux_test_plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	printf 'tmux bind-key R run-shell foo_command\n' > "${xdg_plugin_dir}/test_plugin.tmux"
	chmod +x "${xdg_plugin_dir}/test_plugin.tmux"

	tmux new-session -d
	check_tpm_path "${xdg_dir}/plugins/" ||
		fail_helper "XDG TPM path not correct when only XDG tmux.conf exists"
	tmux list-keys | grep -Eq "R[[:space:]]+run-shell foo_command" ||
		fail_helper "XDG tmux.conf plugin sourcing fails"

	rm -rf "$xdg_dir"
	teardown_helper
}

test_legacy_tmux_conf_precedence_over_xdg() {
	local xdg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
	local xdg_conf="${xdg_dir}/tmux.conf"
	mkdir -p "$xdg_dir"
	cat > "$xdg_conf" <<- HERE
	set -g mode-keys emacs
	HERE

	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "doesnt_matter/tmux_test_plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	create_test_plugin_helper <<- HERE
	tmux bind-key R run-shell foo_command
	HERE

	tmux new-session -d
	check_tpm_path "${PLUGINS_DIR}/" ||
		fail_helper "Legacy ~/.tmux.conf should set default TPM path even when XDG tmux.conf exists"
	tmux list-keys | grep -Eq "R[[:space:]]+run-shell foo_command" ||
		fail_helper "Legacy ~/.tmux.conf should take precedence over XDG tmux.conf"

	rm -rf "$xdg_dir"
	teardown_helper
}

run_tests
