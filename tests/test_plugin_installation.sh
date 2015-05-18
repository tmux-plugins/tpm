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

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @tpm_plugins "tmux-plugins/tmux-example-plugin"
	run-shell "$PWD/tpm"
	HERE

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_plugin_download ||
		fail_helper "Tmux plugin installation fails"

	# check plugin dir exists after download
	check_dir_exists_helper "$HOME/.tmux/plugins/tmux-example-plugin/" ||
		fail_helper "Plugin download fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
