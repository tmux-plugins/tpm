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

manually_install_the_plugin() {
	mkdir_p ~/.tmux/plugins/
	cd ~/.tmux/plugins/
	git clone --quiet https://github.com/tmux-plugins/tmux-example-plugin
}

test_plugin_installation() {
	set_tmux_conf_helper <<- HERE
	set -g @plugin "tmux-plugins/tmux-example-plugin"
	run-shell "$PWD/tpm"
	HERE

	manually_install_the_plugin

	# opens tmux and test it with `expect`
	"$CURRENT_DIR"/expect_successful_update_of_all_plugins ||
		fail_helper "Tmux 'update all plugins' fails"

	"$CURRENT_DIR"/expect_successful_update_of_a_single_plugin ||
		fail_helper "Tmux 'update single plugin' fails"

	teardown_helper
}

main() {
	test_plugin_installation
	exit_value_helper
}
main
