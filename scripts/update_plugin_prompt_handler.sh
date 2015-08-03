#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HELPERS_DIR="$CURRENT_DIR/helpers"

if [ $# -eq 0 ]; then
	exit 0
fi

source "$HELPERS_DIR/tmux_echo_functions.sh"
source "$HELPERS_DIR/tmux_utils.sh"

main() {
	"$CURRENT_DIR/update_plugin.sh" --tmux-echo "$*"
	reload_tmux_environment
	end_message
}
main "$*"
