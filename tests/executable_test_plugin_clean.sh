#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TPM_DIR="$PWD"
PLUGINS_DIR="$HOME/.tmux/plugins"

source "$CURRENT_DIR/helpers/helpers.sh"
source "$CURRENT_DIR/helpers/tpm.sh"

manually_install_the_plugin() {
	rm -rf "$PLUGINS_DIR"
	mkdir -p "$PLUGINS_DIR"
	cd "$PLUGINS_DIR"
	git clone --quiet https://github.com/tmux-plugins/tmux-example-plugin
}

# TMUX KEY-BINDING TESTS

test_plugin_uninstallation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin

	"$CURRENT_DIR/expect_successful_clean_plugins" ||
		fail_helper "[key-binding] clean fails"

	teardown_helper
}

# SCRIPT TESTS

test_plugin_uninstallation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin

	script_run_helper "$TPM_DIR/bin/clean_plugins" '"tmux-example-plugin" clean success' ||
		fail_helper "[script] plugin cleaning fails"

	teardown_helper
}

test_unsuccessful_plugin_uninstallation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g mode-keys vi
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin
	chmod 000 "$PLUGINS_DIR/tmux-example-plugin" # disable directory deletion

	local expected_exit_code=1
	script_run_helper "$TPM_DIR/bin/clean_plugins" '"tmux-example-plugin" clean fail' "$expected_exit_code" ||
		fail_helper "[script] unsuccessful plugin cleaning doesn't fail"

	chmod 755 "$PLUGINS_DIR/tmux-example-plugin" # enable directory deletion

	teardown_helper
}

run_tests
