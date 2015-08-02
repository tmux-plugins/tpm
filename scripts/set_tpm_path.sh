#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"

tpm_path_set() {
	tmux show-environment -g "$DEFAULT_TPM_ENV_VAR_NAME"
}

set_default_tpm_path() {
	tmux set-environment -g "$DEFAULT_TPM_ENV_VAR_NAME" "$DEFAULT_TPM_PATH"
}

main() {
	if ! tpm_path_set; then
		set_default_tpm_path
	fi
}
main
