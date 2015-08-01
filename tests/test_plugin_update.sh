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

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin

	# opens tmux and test it with `expect`
	"$CURRENT_DIR/expect_successful_update_of_all_plugins" ||
		fail_helper "Tmux 'update all plugins' fails"

	"$CURRENT_DIR/expect_successful_update_of_a_single_plugin" ||
		fail_helper "Tmux 'update single plugin' fails"

	teardown_helper
}

run_tests
