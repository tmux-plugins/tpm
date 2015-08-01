#!/usr/bin/env bash

# Script intended for use via the command line.
#
# `.tmux.conf` needs to be set for TPM. Tmux has to be installed on the system,
# but does not need to be started in order to run this script.

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/../scripts"

main() {
	"$SCRIPTS_DIR/install_plugins.sh" # has correct exit code
}
main
