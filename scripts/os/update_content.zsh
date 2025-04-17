#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures update_content tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


verify_git_config() {
    if ! git config --get user.name &> /dev/null; then
        print_error "Git user.name is not set"
        ask "Enter your name: "
        git config --global user.name "$REPLY"
    fi

    if ! git config --get user.email &> /dev/null; then
        print_error "Git user.email is not set"
        ask "Enter your email: "
        git config --global user.email "$REPLY"
    fi
}

verify_github_ssh() {
    print_in_purple "
 >> Verifying GitHub SSH access

"
    
    if ! ssh -T git@github.com &> /dev/null; then
        if [[ $? -ne 1 ]]; then
            source "${SCRIPT_DIR}/set_github_ssh_key.zsh" || return 1
        fi
    else
        print_success "GitHub SSH access verified"
    fi
}

update_jarvistoolset() {
    local current_branch
    current_branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    
    if [[ -z "$current_branch" ]]; then
        print_error "Not in a git repository"
        return 1
    fi

    print_in_purple "
 >> Updating jarvistoolset content

"

    # Stash any local changes
    if ! git diff --quiet HEAD; then
        print_warning "Stashing local changes"
        git stash push -m "Auto-stash before updating content"
    fi

    # Fetch and update
    if execute "git fetch --all" "Fetching updates"; then
        if execute "git reset --hard origin/$current_branch" "Updating to latest version"; then
            execute "git clean -fd" "Cleaning up"
            
            # Pop stashed changes if any
            if git stash list | grep -q "Auto-stash before updating content"; then
                print_warning "Restoring local changes"
                git stash pop
            fi
            
            print_success "jarvistoolset updated successfully"
            
            # Check if we need to run setup again
            if [[ -f "${SCRIPT_DIR}/install/main.zsh" ]]; then
                ask_for_confirmation "Would you like to run the setup script to apply any new changes?"
                if answer_is_yes; then
                    source "${SCRIPT_DIR}/install/main.zsh"
                fi
            fi
        else
            print_error "Failed to update jarvistoolset"
            return 1
        fi
    else
        print_error "Failed to fetch updates"
        return 1
    fi
}

main() {
    # Ensure we're in a git repository
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        print_error "Not in a git repository"
        return 1
    fi

    # Verify git configuration
    verify_git_config

    # Verify GitHub SSH access
    verify_github_ssh || return 1

    # Update jarvistoolset content
    ask_for_confirmation "Would you like to update the jarvistoolset content?"
    if answer_is_yes; then
        update_jarvistoolset
    fi
}

main "$@"
