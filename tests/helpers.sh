#!/bin/sh

FAIL="false"

mkdir_p()
{   #portable mkdir -p function
    local dir subdir
    for dir; do
        mkdir_p__IFS="$IFS"
        IFS="/"
        set -- $dir
        IFS="$mkdir_p__IFS"
        (
        case "$dir" in
            /*) cd /; shift ;;
        esac
        for subdir; do
            [ -z "${subdir}" ] && continue
            if [ -d "${subdir}" ] || mkdir "${subdir}"; then
                if cd "${subdir}"; then
                    :
                else
                    printf "%s\\n" "mkdir_p: Can't enter ${subdir} while creating ${dir}"
                    exit 1
                fi
            else
                exit 1
            fi
        done
        )
    done
}

set_tmux_conf_helper() {
	> ~/.tmux.conf	# empty filename
	while read -r line; do
		printf "%s\\n" "${line}" >> ~/.tmux.conf
	done
}

create_test_plugin_helper() {
	local plugin_path="$HOME/.tmux/plugins/tmux_test_plugin/"
	rm -rf  "$plugin_path"
	mkdir_p "$plugin_path"

	while read -r line; do
		printf "%s\\n" "$line" >> "$plugin_path/test_plugin.tmux"
	done
	chmod +x "$plugin_path/test_plugin.tmux"
}

teardown_helper() {
	rm ~/.tmux.conf
	rm -rf ~/.tmux/
	tmux kill-server >/dev/null 2>&1
}

check_dir_exists_helper() {
	local dir_path=$1
	if [ -d "$dir_path" ]; then
		return 0
	else
		return 1
	fi
}

fail_helper() {
	local message="$1"
	printf "%s\\n" "$message" >&2
	FAIL="true"
}

exit_value_helper() {
	local fail="$1"
	if [ "$FAIL" = "true" ]; then
		printf "%s\\n" "FAIL!"
		printf "\\n"
		exit 1
	else
		printf "%s\\n" "SUCCESS"
		printf "\\n"
		exit 0
	fi
}
