#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/helpers.sh

manually_install_the_plugin() {
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/
	git clone --quiet https://github.com/tmux-plugins/tmux-example-plugin
}

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins "tmux-plugins/tmux-example-plugin"
	run-shell "~/tpm/tpm"
	HERE

	manually_install_the_plugin

	# opens tmux and test it with `expect`
	$CURRENT_DIR/expect_successful_update_of_all_plugins ||
		fail_helper "Tmux 'update all plugins' fails"

	$CURRENT_DIR/expect_successful_update_of_a_single_plugin ||
		fail_helper "Tmux 'update single plugin' fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
