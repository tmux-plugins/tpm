#!/usr/bin/env bash

default_tpm_path="$HOME/.tmux/plugins/"

tpm_path_set() {
	tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH
}

set_default_tpm_path() {
	tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$default_tpm_path"
}

ensure_tpm_path() {
	if ! tpm_path_set; then
		set_default_tpm_path
	fi
}

main() {
	ensure_tpm_path
}
main
