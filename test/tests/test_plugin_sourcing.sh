#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURRENT_DIR/helpers.sh

export FAIL=false

check_binding_defined() {
    local binding=$1
    tmux list-keys | grep -q "$binding"
}

test_plugin_sourcing() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins "doesnt_matter/tmux_test_plugin"
	# change this
	run-shell '~/tmux_plugin_manager/tpm'
	HERE

	create_test_plugin_helper <<- HERE
	tmux bind-key R run-shell foo_command
	HERE

  tmux new-session -d  # tmux starts detached
  check_binding_defined 'R run-shell foo_command' ||
      (echo "Plugin sourcing fails" >&2; FAIL=true)

	teardown_helper
}

main() {
    test_plugin_sourcing
    exit_value_helper
}
main
