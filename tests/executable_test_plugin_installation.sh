#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGINS_DIR="$HOME/.tmux/plugins"
TPM_DIR="$PWD"

CUSTOM_PLUGINS_DIR="$HOME/foo/plugins"
ADDITIONAL_CONFIG_FILE_1="$HOME/.tmux/additional_config_file_1"
ADDITIONAL_CONFIG_FILE_2="$HOME/.tmux/additional_config_file_2"

source "$CURRENT_DIR/helpers/helpers.sh"
source "$CURRENT_DIR/helpers/tpm.sh"

# TMUX KEY-BINDING TESTS

test_plugin_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	"$CURRENT_DIR/expect_successful_plugin_download" ||
		fail_helper "[key-binding] plugin installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding] plugin download fails"

	teardown_helper
}

test_plugin_installation_via_tmux_key_binding_set_option() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set-option -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	"$CURRENT_DIR/expect_successful_plugin_download" ||
		fail_helper "[key-binding][set-option] plugin installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding][set-option] plugin download fails"

	teardown_helper
}

test_plugin_installation_custom_dir_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set-environment -g TMUX_PLUGIN_MANAGER_PATH '$CUSTOM_PLUGINS_DIR'

	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	"$CURRENT_DIR/expect_successful_plugin_download" ||
		fail_helper "[key-binding][custom dir] plugin installation fails"

	check_dir_exists_helper "$CUSTOM_PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding][custom dir] plugin download fails"

	teardown_helper
	rm -rf "$CUSTOM_PLUGINS_DIR"
}

test_non_existing_plugin_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/non-existing-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	"$CURRENT_DIR/expect_failed_plugin_download" ||
		fail_helper "[key-binding] non existing plugin installation doesn't fail"

	teardown_helper
}

test_multiple_plugins_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	\ \ set  -g    @plugin 'tmux-plugins/tmux-copycat'
	run-shell "$TPM_DIR/tpm"
	HERE

	"$CURRENT_DIR/expect_successful_multiple_plugins_download" ||
		fail_helper "[key-binding] multiple plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[key-binding] plugin download fails (tmux-copycat)"

	teardown_helper
}

test_plugins_installation_from_sourced_file_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	source '$ADDITIONAL_CONFIG_FILE_1'
	set -g @plugin 'tmux-plugins/tmux-example-plugin'
	run-shell "$TPM_DIR/tpm"
	HERE

	mkdir ~/.tmux
	echo "set -g @plugin 'tmux-plugins/tmux-copycat'" > "$ADDITIONAL_CONFIG_FILE_1"

	"$CURRENT_DIR/expect_successful_multiple_plugins_download" ||
		fail_helper "[key-binding][sourced file] plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding][sourced file] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[key-binding][sourced file] plugin download fails (tmux-copycat)"

	teardown_helper
}

test_plugins_installation_from_multiple_sourced_files_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	\ \ source    '$ADDITIONAL_CONFIG_FILE_1'
	source-file '$ADDITIONAL_CONFIG_FILE_2'
	run-shell "$TPM_DIR/tpm"
	HERE

	mkdir ~/.tmux
	echo "set -g @plugin 'tmux-plugins/tmux-example-plugin'" > "$ADDITIONAL_CONFIG_FILE_1"
	echo "  set -g @plugin 'tmux-plugins/tmux-copycat'" > "$ADDITIONAL_CONFIG_FILE_2"

	"$CURRENT_DIR/expect_successful_multiple_plugins_download" ||
		fail_helper "[key-binding][multiple sourced files] plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding][multiple sourced files] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[key-binding][multiple sourced files] plugin download fails (tmux-copycat)"

	teardown_helper
}

# SCRIPT TESTS

test_plugin_installation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	script_run_helper "$TPM_DIR/bin/install_plugins" '"tmux-example-plugin" download success' ||
		fail_helper "[script] plugin installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[script] plugin download fails"

	script_run_helper "$TPM_DIR/bin/install_plugins" 'Already installed "tmux-example-plugin"' ||
		fail_helper "[script] plugin already installed message fail"

	teardown_helper
}

test_plugin_installation_custom_dir_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set-environment -g TMUX_PLUGIN_MANAGER_PATH '$CUSTOM_PLUGINS_DIR'

	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	script_run_helper "$TPM_DIR/bin/install_plugins" '"tmux-example-plugin" download success' ||
		fail_helper "[script][custom dir] plugin installation fails"

	check_dir_exists_helper "$CUSTOM_PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[script][custom dir] plugin download fails"

	script_run_helper "$TPM_DIR/bin/install_plugins" 'Already installed "tmux-example-plugin"' ||
		fail_helper "[script][custom dir] plugin already installed message fail"

	teardown_helper
	rm -rf "$CUSTOM_PLUGINS_DIR"
}

test_non_existing_plugin_installation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/non-existing-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	local expected_exit_code=1
	script_run_helper "$TPM_DIR/bin/install_plugins" '"non-existing-plugin" download fail' "$expected_exit_code" ||
		fail_helper "[script] non existing plugin installation doesn't fail"

	teardown_helper
}

test_multiple_plugins_installation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	\ \ set  -g    @plugin 'tmux-plugins/tmux-copycat'
	run-shell "$TPM_DIR/tpm"
	HERE

	script_run_helper "$TPM_DIR/bin/install_plugins" '"tmux-example-plugin" download success' ||
		fail_helper "[script] multiple plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[script] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[script] plugin download fails (tmux-copycat)"

	script_run_helper "$TPM_DIR/bin/install_plugins" 'Already installed "tmux-copycat"' ||
		fail_helper "[script] multiple plugins already installed message fail"

	teardown_helper
}

test_plugins_installation_from_sourced_file_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	source '$ADDITIONAL_CONFIG_FILE_1'
	set -g @plugin 'tmux-plugins/tmux-example-plugin'
	run-shell "$TPM_DIR/tpm"
	HERE

	mkdir ~/.tmux
	echo "set -g @plugin 'tmux-plugins/tmux-copycat'" > "$ADDITIONAL_CONFIG_FILE_1"

	script_run_helper "$TPM_DIR/bin/install_plugins" '"tmux-copycat" download success' ||
		fail_helper "[script][sourced file] plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[script][sourced file] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[script][sourced file] plugin download fails (tmux-copycat)"

	script_run_helper "$TPM_DIR/bin/install_plugins" 'Already installed "tmux-copycat"' ||
		fail_helper "[script][sourced file] plugins already installed message fail"

	teardown_helper
}

test_plugins_installation_from_multiple_sourced_files_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	\ \ source    '$ADDITIONAL_CONFIG_FILE_1'
	source-file '$ADDITIONAL_CONFIG_FILE_2'
	set -g @plugin 'tmux-plugins/tmux-example-plugin'
	run-shell "$TPM_DIR/tpm"
	HERE

	mkdir ~/.tmux
	echo " set   -g @plugin 'tmux-plugins/tmux-copycat'" > "$ADDITIONAL_CONFIG_FILE_1"
	echo "set -g @plugin 'tmux-plugins/tmux-sensible'" > "$ADDITIONAL_CONFIG_FILE_2"

	script_run_helper "$TPM_DIR/bin/install_plugins" '"tmux-sensible" download success' ||
		fail_helper "[script][multiple sourced files] plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[script][multiple sourced files] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[script][multiple sourced files] plugin download fails (tmux-copycat)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-sensible/" ||
		fail_helper "[script][multiple sourced files] plugin download fails (tmux-sensible)"

	script_run_helper "$TPM_DIR/bin/install_plugins" 'Already installed "tmux-sensible"' ||
		fail_helper "[script][multiple sourced files] plugins already installed message fail"

	teardown_helper
}

run_tests
