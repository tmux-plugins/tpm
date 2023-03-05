install_key_option="@tpm-install"
default_install_key="I"

update_key_option="@tpm-update"
default_update_key="U"

clean_key_option="@tpm-clean"
default_clean_key="M-u"

# TODO
# Since command-alias was not previosly used in tpm we need to make sure
# that the version here reflects the requirements for the command-alias to
# be present the required version for command-alias to work
SUPPORTED_TMUX_VERSION="1.9"

DEFAULT_TPM_ENV_VAR_NAME="TMUX_PLUGIN_MANAGER_PATH"
DEFAULT_TPM_PATH="$HOME/.tmux/plugins/"
