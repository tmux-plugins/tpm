#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR"/helpers.sh

manually_install_the_plugin() {
	rm -rf   ~/.tmux/plugins/
	mkdir -p ~/.tmux/plugins/
	cd ~/.tmux/plugins/
	git clone --quiet https://github.com/tmux-plugins/tmux-example-plugin
}

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	run-shell "$PWD/tpm"
	HERE

	manually_install_the_plugin

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_clean_plugins ||
		fail_helper "Clean fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
