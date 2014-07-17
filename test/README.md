# TPM tests

- all testing is done with vagrant for complete isolation from
  local development environment.
- `expect` program is used for testing tmux client (keybindings and some output)

#### Running tests

Requirements: [vagrant](https://www.vagrantup.com/)

Running test suite is easy:

    # within `tpm` project directory

    $ cd test           # enter test directory
    $ ./run             # runs all the tests
