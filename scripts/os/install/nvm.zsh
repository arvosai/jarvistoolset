#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../utils.zsh"

# Define constants
typeset -r LOCAL_SHELL_CONFIG_FILE="$HOME/.zshrc.local"
typeset -r NVM_DIRECTORY="$HOME/.nvm"
typeset -r NVM_GIT_REPO_URL="https://github.com/nvm-sh/nvm.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures nvm tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Create a banner for this installation script
create_install_banner "$0"


add_nvm_configs() {
    typeset -r CONFIGS="
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Node Version Manager
export NVM_DIR=\"$NVM_DIRECTORY\"
[ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\"  # This loads nvm
[ -s \"\$NVM_DIR/bash_completion\" ] && source \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion
"

    # Add the nvm configurations if they are not already there
    if ! grep -q "NVM_DIR" "$LOCAL_SHELL_CONFIG_FILE" 2> /dev/null; then
        execute \
            "printf '%s' '$CONFIGS' >> $LOCAL_SHELL_CONFIG_FILE \
                && source $LOCAL_SHELL_CONFIG_FILE" \
            "nvm (update $LOCAL_SHELL_CONFIG_FILE)"
    fi
}

install_latest_stable_node() {
    # Install the latest LTS version of Node
    execute \
        ". $NVM_DIRECTORY/nvm.sh \
            && nvm install --lts \
            && nvm use --lts \
            && nvm alias default 'lts/*'" \
        "nvm (install latest LTS version)"
}

install_nvm() {
    # Install nvm or update it
    if [ ! -d "$NVM_DIRECTORY" ]; then
        execute \
            "git clone --quiet $NVM_GIT_REPO_URL $NVM_DIRECTORY" \
            "nvm (install)" \
            || return 1
    fi

    # Source nvm
    [ -s "$NVM_DIRECTORY/nvm.sh" ] && source "$NVM_DIRECTORY/nvm.sh"
}

update_nvm() {
    execute \
        "cd $NVM_DIRECTORY \
            && git fetch --quiet origin \
            && git checkout --quiet \$(git describe --abbrev=0 --tags) \
            && . $NVM_DIRECTORY/nvm.sh" \
        "nvm (upgrade)"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "
   nvm

"

    install_nvm
    add_nvm_configs
    update_nvm
    install_latest_stable_node
}

main
