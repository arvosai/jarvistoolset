#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures vim tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Create a banner for this installation script
create_install_banner "$0"


install_plugins() {
    local -r VUNDLE_DIR="$HOME/.vim/plugins/Vundle.vim"
    local -r VUNDLE_GIT_REPO_URL="https://github.com/VundleVim/Vundle.vim.git"

    # Install plugins.
    execute \
        "rm -rf '$VUNDLE_DIR' \
            && git clone --quiet '$VUNDLE_GIT_REPO_URL' '$VUNDLE_DIR' \
            && printf '
' | vim +PluginInstall +qall" \
        "Install vim plugins"

    # Install additional things required by some plugins.
    execute \
        ". $HOME/.zshrc \
            && cd $HOME/.vim/plugins/tern_for_vim \
            && npm install" \
        "Install plugins (extra installs for 'tern_for_vim')"
}

update_plugins() {
    execute \
        "vim +PluginUpdate +qall" \
        "Update vim plugins"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "
   Vim

"

    # Install vim if not already installed
    brew_install "vim"

    # Install/Update vim plugins
    install_plugins
    update_plugins
}

main
