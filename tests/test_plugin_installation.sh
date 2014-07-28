#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/helpers.sh

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins "tmux-plugins/tmux-example-plugin"
	run-shell "~/tpm/tpm"
	HERE

	# opens tmux and test it with `expect`
	$CURRENT_DIR/expect_successful_plugin_download ||
		fail_helper "Tmux plugin installation fails"

	# check plugin dir exists after download
	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "Plugin download fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
