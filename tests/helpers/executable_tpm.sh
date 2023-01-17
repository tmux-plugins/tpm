check_dir_exists_helper() {
	[ -d "$1" ]
}

# runs the scripts and asserts it has the correct output and exit code
script_run_helper() {
	local script="$1"
	local expected_output="$2"
	local expected_exit_code="${3:-0}"
	$script 2>&1 |
		grep "$expected_output" >/dev/null 2>&1 && # grep -q flag quits the script early
		[ "${PIPESTATUS[0]}" -eq "$expected_exit_code" ]
}
