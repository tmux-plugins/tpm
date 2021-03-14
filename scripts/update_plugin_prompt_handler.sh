#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR"
HELPERS_DIR="$CURRENT_DIR/helpers"

if [ $# -eq 0 ]; then
	exit 0
fi

source "$HELPERS_DIR/tmux_echo_functions.sh"
# NOTE: This line redifines CURRENT_DIR
source "$HELPERS_DIR/tmux_utils.sh"

main() {
	"$SCRIPTS_DIR/update_plugin.sh" --tmux-echo "$*"
	reload_tmux_environment
	end_message
}
main "$*"
