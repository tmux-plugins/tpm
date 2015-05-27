#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR"/helpers.sh

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins " \
	tmux-plugins/tmux-example-plugin \
	gh:tmux-plugins/tmux-online-status \
	github:tmux-plugins/tmux-battery \
	github:tmux-plugins/tmux-sidebar:master \
	https://github.com/tmux-plugins/tmux-sensible:3ea5b \
	http://ovh.net/files/sha1sum.txt \
	git://git.openembedded.org/meta-micro \
	ftp://ftp.microsoft.com/developr/readme.txt \
	file://$PWD/tests/run-tests-within-vm"
	run-shell "$PWD/tpm"
	HERE

	# opens tmux and install plugins, test results with `expect`
	"$CURRENT_DIR"/expect_successful_plugin_download_extended ||
		fail_helper "Tmux plugin installation phase in update fails"

	# opens tmux and update plugins, test results with `expect`
	"$CURRENT_DIR"/expect_successful_update_of_all_plugins ||
		fail_helper "Tmux 'update all plugins' fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
