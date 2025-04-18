#!/usr/bin/env zsh

cd "$(dirname "${(%):-%x}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures set_github_ssh_key tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


add_ssh_configs() {

    printf "%s
" \
        "Host github.com" \
        "  IdentityFile ${1}" \
        "  LogLevel ERROR" >> ~/.ssh/config

    print_result $? "Adding SSH configuration"

}

copy_public_ssh_key_to_clipboard () {

    if (( $+commands[pbcopy] )); then

        pbcopy < "$1"
        print_result $? "Copying SSH public key to clipboard"

    elif (( $+commands[xclip] )); then

        xclip -selection clip < "$1"
        print_result $? "Copying SSH public key to clipboard"

    else
        print_warning "Please, copy the SSH public key ($1) to the clipboard"
    fi

}

generate_ssh_keys() {

    ask "Enter your email: " && printf "
"
    ssh-keygen -t rsa -b 4096 -C "$(get_answer)" -f "$1"

    print_result $? "Generating SSH keys..."

}

open_github_ssh_page() {

    typeset -r GITHUB_SSH_URL="https://github.com/settings/ssh"

    # The order of the following checks matters
    # as on Ubuntu there is also a utility called `open`.

    if (( $+commands[xdg-open] )); then
        xdg-open "$GITHUB_SSH_URL"
    elif (( $+commands[open] )); then
        open "$GITHUB_SSH_URL"
    else
        print_warning "Please, add the SSH key to GitHub ($GITHUB_SSH_URL)"
    fi

}

set_github_ssh_key() {

    local sshKeyFileName="$HOME/.ssh/github"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If there is already a file with that
    # name, generate another, unique, file name.

    if [ -f "$sshKeyFileName" ]; then
        sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    generate_ssh_keys "$sshKeyFileName"
    add_ssh_configs "$sshKeyFileName"
    copy_public_ssh_key_to_clipboard "${sshKeyFileName}.pub"
    open_github_ssh_page
    test_ssh_connection \
        && rm "${sshKeyFileName}.pub"

}

test_ssh_connection() {

    while true; do

        ssh -T git@github.com &> /dev/null
        (( $? -eq 1 )) && break

        sleep 5

    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "
 >> Configuring SSH keys on GitHub

"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_git_repository; then
        print_error "Not a Git repository"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ssh -T git@github.com &> /dev/null

    if (( $? -ne 1 )); then
        set_github_ssh_key
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_result $? "Configuring SSH keys on GitHub"

}

main
