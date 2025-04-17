#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures restart tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


save_open_files() {
    # Save any open files in common editors if they're running
    local -a editors=(
        "code"        # VS Code
        "nvim"        # Neovim
        "vim"         # Vim
        "subl"        # Sublime Text
    )

    for editor in $editors; do
        if cmd_exists "$editor"; then
            case "$editor" in
                "code")
                    # VS Code - save all files
                    pkill -SIGUSR1 "code" 2>/dev/null
                    ;;
                "nvim"|"vim")
                    # Neovim/Vim - save and quit all instances
                    pkill -SIGUSR1 "$editor" 2>/dev/null
                    ;;
                "subl")
                    # Sublime Text - save all files
                    pkill -SIGUSR1 "subl" 2>/dev/null
                    ;;
            esac
        fi
    done
}

restart_system() {
    print_in_purple "
 >> System restart

"

    ask_for_confirmation "Are you sure you want to restart the system?"
    printf "
"

    if answer_is_yes; then
        # Save any open files
        save_open_files

        # Check for running processes that might prevent restart
        local -a important_processes=(
            "brew"              # Homebrew operations
            "npm"              # NPM installations
            "pip"              # Python package installations
            "gem"              # Ruby gem installations
            "docker"           # Docker operations
            "composer"         # PHP Composer operations
            "git"              # Git operations
        )

        local has_running_processes=false
        for process in $important_processes; do
            if pgrep -x "$process" >/dev/null; then
                has_running_processes=true
                print_warning "$process is still running"
            fi
        done

        if $has_running_processes; then
            ask_for_confirmation "Some important processes are still running. Continue anyway?"
            if ! answer_is_yes; then
                print_error "Restart cancelled"
                return 1
            fi
        fi

        # Execute restart
        print_warning "System will restart in 5 seconds..."
        sleep 5
        execute "sudo shutdown -r now" "Restarting system"
    fi
}

main() {
    # Verify sudo access upfront
    ask_for_sudo

    restart_system
}

main "$@"
