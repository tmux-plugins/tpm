#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/helpers.sh

# TMUX KEY-BINDING TESTS

test_plugin_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$PWD/tpm"
	HERE

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_plugin_download ||
		fail_helper "[key-binding] plugin installation fails"

	# check plugin dir exists after download
	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "[key-binding] plugin download fails"

	teardown_helper
}

test_multiple_plugins_installation_via_tmux_key_binding() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	\ \ set  -g    @plugin 'tmux-plugins/tmux-copycat'
	run-shell "$PWD/tpm"
	HERE

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_multiple_plugins_download ||
		fail_helper "[key-binding] multiple plugins installation fails"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "[key-binding] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-copycat/" ||
		fail_helper "[key-binding] plugin download fails (tmux-copycat)"

	teardown_helper
}

# SCRIPT TESTS

test_plugin_installation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$PWD/tpm"
	HERE

	script_run_helper "$PWD/bin/install_plugins" '"tmux-example-plugin" download success' ||
		fail_helper "[script] plugin installation fails"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "[script] plugin download fails"

	script_run_helper "$PWD/bin/install_plugins" 'Already installed "tmux-example-plugin"' ||
		fail_helper "[script] plugin already installed message fail"

	teardown_helper
}

test_multiple_plugins_installation_via_script() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	\ \ set  -g    @plugin 'tmux-plugins/tmux-copycat'
	run-shell "$PWD/tpm"
	HERE

	script_run_helper "$PWD/bin/install_plugins" '"tmux-example-plugin" download success' ||
		fail_helper "[script] multiple plugins installation fails"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "[script] plugin download fails (tmux-example-plugin)"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-copycat/" ||
		fail_helper "[script] plugin download fails (tmux-copycat)"

	script_run_helper "$PWD/bin/install_plugins" 'Already installed "tmux-copycat"' ||
		fail_helper "[script] multiple plugins already installed message fail"

	teardown_helper
}

main() {
	test_plugin_installation_via_tmux_key_binding
	test_multiple_plugins_installation_via_tmux_key_binding

	test_plugin_installation_via_script
	test_multiple_plugins_installation_via_script

	exit_value_helper
}
main
