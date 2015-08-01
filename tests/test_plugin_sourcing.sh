#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TPM_DIR="$PWD"

source "$CURRENT_DIR/helpers/helpers.sh"
source "$CURRENT_DIR/helpers/tpm.sh"

check_binding_defined() {
	local binding="$1"
	tmux list-keys | grep -q "$binding"
}

create_test_plugin_helper() {
	local plugin_path="$HOME/.tmux/plugins/tmux_test_plugin/"
	rm -rf $plugin_path
	mkdir -p $plugin_path

	while read -r line; do
		echo $line >> "$plugin_path/test_plugin.tmux"
	done
	chmod +x "$plugin_path/test_plugin.tmux"
}

test_plugin_sourcing() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "doesnt_matter/tmux_test_plugin"
	run-shell "$TPM_DIR/tpm"
	HERE

	# manually creates a local tmux plugin
	create_test_plugin_helper <<- HERE
	tmux bind-key R run-shell foo_command
	HERE

	tmux new-session -d  # tmux starts detached
	check_binding_defined "R run-shell foo_command" ||
		fail_helper "Plugin sourcing fails"

	teardown_helper
}

run_tests
