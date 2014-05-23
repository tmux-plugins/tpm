#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# (I)nstalls all plugins
tmux bind-key I run-shell "$CURRENT_DIR/sync_plugins.sh >/dev/null 2>&1"
