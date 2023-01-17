#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TPM_DIR="$PWD"
PLUGINS_DIR="$HOME/.tmux/plugins"

source "$CURRENT_DIR/helpers/helpers.sh"
source "$CURRENT_DIR/helpers/tpm.sh"

manually_install_the_plugin() {
	mkdir -p "$PLUGINS_DIR"
	cd "$PLUGINS_DIR"
	git clone --quiet https://github.com/tmux-plugins/tmux-example-plugin
}

# TMUX KEY-BINDING TESTS

test_plugin_update_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin

	"$CURRENT_DIR/expect_successful_update_of_all_plugins" ||
		fail_helper "[key-binding] 'update all plugins' fails"

	"$CURRENT_DIR/expect_successful_update_of_a_single_plugin" ||
		fail_helper "[key-binding] 'update single plugin' fails"

	teardown_helper
}

# SCRIPT TESTS

test_plugin_update_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin

	local expected_exit_code=1
	script_run_helper "$TPM_DIR/bin/update_plugins" 'usage' "$expected_exit_code" ||
		fail_helper "[script] running update plugins without args should fail"

	script_run_helper "$TPM_DIR/bin/update_plugins tmux-example-plugin" '"tmux-example-plugin" update success' ||
		fail_helper "[script] plugin update fails"

	script_run_helper "$TPM_DIR/bin/update_plugins all" '"tmux-example-plugin" update success' ||
		fail_helper "[script] update all plugins fails"

	teardown_helper
}

run_tests
