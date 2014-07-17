#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/test_helpers.sh

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins "bruno-/tmux_example_plugin"
	run-shell '/root/tmux_plugin_manager/tpm'
	HERE

	# opens tmux and test it with `expect`
	$CURRENT_DIR/expect_successful_plugin_download ||
		(echo "Tmux plugin installation fails" >&2; fail_test)

	# check plugin dir exists after download
	check_dir_exists_helper "/root/.tmux/plugins/tmux_example_plugin/" ||
		(echo "Plugin download fails" >&2; fail_test)

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
