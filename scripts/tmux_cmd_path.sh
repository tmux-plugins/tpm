#!/bin/bash

# Written by michaellee8 <ckmichael8@gmail.com> in Nov 2020 for 
# https://github.com/tmux-plugins/tpm/issues/189 to prevent problems caused by 
# tmux version mismatch between client and server. This script is 
# licensed in public domain.

# Try to get the process ID of the running tmux server, 
# would be empty if not found
TMUX_SERVER_PID=$(ps -eo pid=,comm= | grep 'tmux: server' | awk '{ print $1; }')

if [[ -n "$TMUX_SERVER_PID" ]]; then
    TMUX_CMD_PATH=$(realpath "/proc/$TMUX_SERVER_PID/exe" 2> /dev/null || echo "tmux" | sed -z '$ s/\n$//')
else
    TMUX_CMD_PATH='tmux'
fi

export TMUX_CMD_PATH
