#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TPM_DIR="$PWD"
PLUGINS_DIR="$HOME/.tmux/plugins"

source "$CURRENT_DIR/helpers.sh"

manually_install_the_plugin() {
	rm -rf "$PLUGINS_DIR"
	mkdir -p "$PLUGINS_DIR"
	cd "$PLUGINS_DIR"
	git clone --quiet https://github.com/tmux-plugins/tmux-example-plugin
}

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	run-shell "$TPM_DIR/tpm"
	HERE

	manually_install_the_plugin

	# opens tmux and test it with `expect`
	"$CURRENT_DIR/expect_successful_clean_plugins" ||
		fail_helper "Clean fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
