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

        #tmux; exit 0
	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_plugin_download_extended ||
		 fail_helper "Tmux plugin installation fails"

	# check plugin dir exists after download
	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		 fail_helper "Plugin tmux-plugins/tmux-example-plugin download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-online-status/" ||
		 fail_helper "Plugin gh:tmux-plugins/tmux-online-status download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-battery/" ||
		 fail_helper "Plugin github:tmux-plugins/tmux-battery download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-sidebar/" ||
		 fail_helper "Plugin github:tmux-plugins/tmux-sidebar:master download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-sensible/" ||
		 fail_helper "Plugin https://github.com/tmux-plugins/tmux-sensible:3ea5b download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/sha1sum.txt/" ||
		 fail_helper "Plugin http://ovh.net/files/sha1sum.txt download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/meta-micro/" ||
		 fail_helper "Plugin git://git.openembedded.org/meta-micro download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/readme.txt/" ||
		 fail_helper "Plugin ftp://ftp.microsoft.com/developr/readme.txt download failed"

	check_dir_exists_helper "$HOME/.tmux/plugins/run-tests-within-vm/" ||
		 fail_helper "Plugin file://$PWD/tests/run-tests-within-vm failed"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
