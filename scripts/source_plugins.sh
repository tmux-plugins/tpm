#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

# Sources all *.tmux files from the plugin directory.
# Files are sourced as tmux config files, not as shell scripts!
# No errors if the plugin dir does not exist.
silently_source_all_tmux_files() {
    local plugin_path=$1
    for tmux_file in $plugin_path/*.tmux; do
        tmux run-shell "source-file $tmux_file 2>&1 1>&/dev/null"
    done
}

source_plugin() {
    local plugin=$1
    local plugin_path=$(shared_plugin_path "$plugin")
    silently_source_all_tmux_files "$plugin_path"
}

source_plugins() {
    local plugins=$(shared_get_tpm_plugins_list)
    for plugin in $plugins; do
        source_plugin "$plugin"
    done
}

main() {
    shared_set_tpm_path_constant
    source_plugins
}
main
