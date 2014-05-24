#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared_functions.sh"

# TMUX messaging is weird. You only get a nice clean pane if you do it with
# `run-shell` command.
display_message() {
    local message=$1
    tmux run-shell "echo '$message'"
}

end_message() {
    display_message ""
    display_message "TMUX environment reloaded."
    display_message ""
    display_message "Done, press ENTER to continue."
}

clone() {
    local plugin=$1
    cd $SHARED_TPM_PATH &&
        git clone --recursive $plugin
}

# tries cloning:
# 1. plugin name directly - works if it's a valid git url
# 2. expands the plugin name to point to a github repo and tries cloning again
clone_plugin() {
    local plugin=$1
    clone "$plugin" ||
        clone "https://github.com/$plugin"
}

plugin_already_cloned() {
    local plugin=$1
    local plugin_path=$(shared_plugin_path "$plugin")
    cd $plugin_path &&
        git remote
}

pull_changes() {
    local plugin=$1
    local plugin_path=$(shared_plugin_path "$plugin")
    cd $plugin_path &&
        git pull &&
        git submodule update --init --recursive
}

# pull new changes or clone plugin
sync_plugin() {
    local plugin=$1
    if plugin_already_cloned "$plugin"; then
        # plugin is already cloned - update it
        display_message "Updating $plugin"
        pull_changes "$plugin" &&
            display_message "  $plugin update success" ||
            display_message "  $plugin update fail"
    else
        # plugin wasn't cloned so far - clone it
        display_message "Downloading $plugin"
        clone_plugin "$plugin" &&
            display_message "  $plugin download success" ||
            display_message "  $plugin download fail"
    fi
}

sync_plugins() {
    local plugins=$(shared_get_tpm_plugins_list)
    for plugin in $plugins; do
        sync_plugin "$plugin"
    done
}

ensure_tpm_path_exists() {
    mkdir -p $SHARED_TPM_PATH
}

reload_tmux_environment() {
    tmux source-file ~/.tmux.conf >/dev/null 2>&1
}

main() {
    reload_tmux_environment
    shared_set_tpm_path_constant
    ensure_tpm_path_exists
    sync_plugins
    reload_tmux_environment
    end_message
}
main
