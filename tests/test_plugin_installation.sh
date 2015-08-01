#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGINS_DIR="$HOME/.tmux/plugins"
TPM_DIR="$PWD"

CUSTOM_PLUGINS_DIR="$HOME/foo/plugins"

source "$CURRENT_DIR/helpers/helpers.sh"
source "$CURRENT_DIR/helpers/tpm.sh"

# TMUX KEY-BINDING TESTS

test_plugin_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	"$CURRENT_DIR/expect_successful_plugin_download" ||
		fail_helper "[key-binding] plugin installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding] plugin download fails"

	teardown_helper
}

test_plugin_installation_custom_dir_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
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

test_multiple_plugins_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	\ \ set  -g    @plugin 'tmux-plugins/tmux-copycat'
	run-shell "$TPM_DIR/tpm"
	HERE

	# opens tmux and test it with `expect`
	"$CURRENT_DIR/expect_successful_multiple_plugins_download" ||
		fail_helper "[key-binding] multiple plugins installation fails"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-example-plugin/" ||
		fail_helper "[key-binding] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$PLUGINS_DIR/tmux-copycat/" ||
		fail_helper "[key-binding] plugin download fails (tmux-copycat)"

	teardown_helper
}

# SCRIPT TESTS

test_plugin_installation_via_script() {
	set_tmux_conf_helper <<- HERE
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

test_multiple_plugins_installation_via_script() {
	set_tmux_conf_helper <<- HERE
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

run_tests
