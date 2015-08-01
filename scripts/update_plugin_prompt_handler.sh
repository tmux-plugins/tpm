#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $# -eq 0]; then
	exit 0
fi

source "$CURRENT_DIR/shared_functions.sh"

main() {
	"$CURRENT_DIR/update_plugin.sh" --tmux-echo "$*"
	reload_tmux_environment
	end_message
}
main "$*"
