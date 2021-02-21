
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPTS_DIR="$CURRENT_DIR/../../scripts"
HELPERS_DIR="$SCRIPTS_DIR/helpers"
source "$SCRIPTS_DIR/tmux_cmd_path.sh"

reload_tmux_environment() {
	$TMUX_CMD_PATH source-file ~/.tmux.conf >/dev/null 2>&1
}
