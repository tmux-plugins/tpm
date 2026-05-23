#!/usr/bin/env bash

echo_ok() {
	echo "$*"
}

echo_err() {
	fail_helper "$*"
}
