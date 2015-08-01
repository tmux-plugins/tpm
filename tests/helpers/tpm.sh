check_dir_exists_helper() {
	local dir_path=$1
	if [ -d "$dir_path" ]; then
		return 0
	else
		return 1
	fi
}

# runs the scripts and asserts it has the correct output and exit code
script_run_helper() {
	local script="$1"
	local expected_output="$2"
	local expected_exit_code="${3:-0}"
	"$script" |
		grep "$expected_output" >/dev/null 2>&1 && # grep -q flag quits the script early
		[ "${PIPESTATUS[0]}" -eq "$expected_exit_code" ]
}
