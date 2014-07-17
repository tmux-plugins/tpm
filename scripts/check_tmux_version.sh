#!/usr/bin/env bash

VERSION="$1"
UNSUPPORTED_MSG="$2"

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

# Ensures a message is displayed for 5 seconds in tmux prompt.
# Does not override the 'display-time' tmux option.
display_message() {
	local message="$1"

	# display_duration defaults to 5 seconds, if not passed as an argument
	if [ "$#" -eq 2 ]; then
		local display_duration="$2"
	else
		local display_duration="5000"
	fi

	# saves user-set 'display-time' option
	local saved_display_time=$(get_tmux_option "display-time" "750")

	# sets message display time to 5 seconds
	tmux set-option -gq display-time "$display_duration"

	# displays message
	tmux display-message "$message"

	# restores original 'display-time' value
	tmux set-option -gq display-time "$saved_display_time"
}

# this is used to get "clean" integer version number. Examples:
# `tmux 1.9` => `19`
# `1.9a`     => `19`
get_digits_from_string() {
	local string="$1"
	local only_digits="$(echo "$string" | tr -dC '[:digit:]')"
	echo "$only_digits"
}

tmux_version_int() {
	local tmux_version_string=$(tmux -V)
	echo "$(get_digits_from_string "$tmux_version_string")"
}

unsupported_version_message() {
	if [ -n "$UNSUPPORTED_MSG" ]; then
		echo "$UNSUPPORTED_MSG"
	else
		echo "Error, Tmux version unsupported! Please install Tmux version $VERSION or greater!"
	fi
}

exit_if_unsupported_version() {
	local current_version="$1"
	local supported_version="$2"
	if [ "$current_version" -lt "$supported_version" ]; then
		display_message "$(unsupported_version_message)"
		exit 1
	fi
}

main() {
	local supported_version_int="$(get_digits_from_string "$VERSION")"
	local current_version_int="$(tmux_version_int)"
	exit_if_unsupported_version "$current_version_int" "$supported_version_int"
}
main
