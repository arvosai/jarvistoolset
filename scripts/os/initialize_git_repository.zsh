#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures initialize_git_repository tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


initialize_git_repository() {
    local -r GIT_ORIGIN="$1"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ -z "$GIT_ORIGIN" ]; then
        print_error "Please provide a Git origin URL"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_git_repository; then

        # Run the following Git commands in the root of
        # the dotfiles directory, not in the `os/` directory.
        cd ../../ \
            || print_error "Failed to move to parent directory"

        execute \
            "git init && git remote add origin $GIT_ORIGIN" \
            "Initialize the Git repository"

        execute "git config --global user.name '$USERNAME'" \
            "Add user '$USERNAME'" 

        execute "git config --global user.email '$EMAIL'" \
            "Add email '$EMAIL'" 

        print_in_purple "
   Git repository initialized successfully

"

    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "
   Initialize Git repository

"
    initialize_git_repository "$1"
}

main "$1"
