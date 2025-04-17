#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"
# Source logging script if available
source "${SCRIPT_DIR}/logging.zsh" 2>/dev/null || true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures create_directories tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


create_directories() {
    # Define directories to create using zsh array syntax
    local -a DIRECTORIES=(
        # XDG Base Directory Specification
        "$HOME/.config"           # User-specific configuration
        "$HOME/.local/bin"       # User-specific executables
        "$HOME/.local/share"     # User-specific data files
        "$HOME/.local/state"     # User-specific state files
        "$HOME/.cache"           # User-specific cache files
        
        # Custom directories
        "$HOME/.personalize"     # Personal customization files
        "$HOME/Projects"         # Development projects
        "$HOME/Workspace"        # Work-related files
        "$HOME/.ssh"            # SSH configuration
        "$HOME/.gnupg"          # GPG configuration
        
        # Development directories
        "$HOME/.npm-global"     # Global npm packages
        "$HOME/.composer"       # Composer packages
        "$HOME/.gradle"         # Gradle configuration
        "$HOME/.m2"            # Maven configuration
        
        # Backup directories
        "$HOME/Backups"        # General backups
        "$HOME/Backups/Apps" \
        "$HOME/Backups/Configs" \
        "$HOME/Backups/.jarvistoolset" # jarvistoolset backups
        
        # Application directories
        "$HOME/.config/nvim"   # Neovim configuration
        "$HOME/.config/git"    # Git configuration
        "$HOME/.config/zsh"    # Zsh configuration
        
        # Jarvistoolset logs directory
        "$HOME/.jarvistoolset/logs" # Installation logs
    )

    print_in_purple "
 >> Creating directories

"
    
    # Log the directory creation process
    if type log_info &>/dev/null; then
        log_info "Creating directories"
    fi

    # Create directories with proper permissions
    for dir in $DIRECTORIES; do
        if mkdir -p "$dir" &>/dev/null; then
            print_success "Created directory: $dir"
            
            # Log directory creation
            if type log_info &>/dev/null; then
                log_success "Created directory: $dir"
            fi
            
            # Set restrictive permissions for sensitive directories
            case "$dir" in
                */.ssh|*/.gnupg)
                    chmod 700 "$dir" &>/dev/null
                    
                    # Log permission setting
                    if type log_info &>/dev/null; then
                        log_info "Set permissions 700 for sensitive directory: $dir"
                    fi
                    ;;
                *)
                    chmod 755 "$dir" &>/dev/null
                    
                    # Log permission setting
                    if type log_info &>/dev/null; then
                        log_info "Set permissions 755 for directory: $dir"
                    fi
                    ;;
            esac
        else
            print_error "Failed to create directory: $dir"
            
            # Log directory creation failure
            if type log_error &>/dev/null; then
                log_error "Failed to create directory: $dir"
            fi
        fi
    done
    
    # Log completion
    if type log_info &>/dev/null; then
        log_success "Directory creation completed"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    # Log main function start
    if type log_info &>/dev/null; then
        log_info "Starting directory creation process"
    fi

    create_directories
    
    # Log main function completion
    if type log_info &>/dev/null; then
        log_success "Directory creation process completed"
    fi
}

main
