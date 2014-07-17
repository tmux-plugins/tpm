#!/usr/bin/env bash

FAIL="false"

set_tmux_conf_helper() {
	> ~/.tmux.conf	# empty filename
	while read -r line; do
		echo $line >> ~/.tmux.conf
	done
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

teardown_helper() {
	rm ~/.tmux.conf
	rm -rf ~/.tmux/
	tmux kill-server >/dev/null 2>&1
}

check_dir_exists_helper() {
	local dir_path=$1
	if [ -d "$dir_path" ]; then
		return 0
	else
		return 1
	fi
}

fail_helper() {
	local message="$1"
	echo "$message" >&2
	FAIL="true"
}

exit_value_helper() {
	local fail="$1"
	if [ "$FAIL" == "true" ]; then
		echo "FAIL!"
		echo
		exit 1
	else
		echo "SUCCESS"
		echo
		exit 0
	fi
}
