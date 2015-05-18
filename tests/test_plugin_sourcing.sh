#!/bin/sh

_dirname()
{   #portable dirname
    [ -z "${1}" ] && return 1

    #http://www.linuxselfhelp.com/gnu/autoconf/html_chapter/autoconf_10.html
    case "${1}" in
        /*|*/*) local dir; dir=$(expr "x${1}" : 'x\(.*\)/[^/]*' \| '.' : '.')
                printf "%s\\n" "${dir}" ;;
             *) printf "%s\\n" ".";;
    esac
}

CURRENT_DIR="$( cd "$( _dirname "$0" )" && pwd )"

. "$CURRENT_DIR"/helpers.sh

check_binding_defined() {
	local binding="$1"
	tmux list-keys | grep -q "$binding"
}

test_plugin_sourcing() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins "doesnt_matter/tmux_test_plugin"
	run-shell "$PWD/tpm"
	HERE

	# manually creates a local tmux plugin
	create_test_plugin_helper <<- HERE
	tmux bind-key R run-shell foo_command
	HERE

	tmux new-session -d  # tmux starts detached
	check_binding_defined "R run-shell foo_command" ||
		fail_helper "Plugin sourcing fails"

	teardown_helper
}

main() {
	test_plugin_sourcing
	exit_value_helper
}
main
