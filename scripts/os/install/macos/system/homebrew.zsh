#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh" 2>/dev/null || true  # Source local utils if available


get_homebrew_git_config_file_path() {
    local path=""

    if path="$(brew --repository 2> /dev/null)/.git/config"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Homebrew (get config file path)"
        return 1
    fi
}

install_homebrew() {
    print_in_purple "\n   Installing Homebrew\n\n"
    
    if ! cmd_exists "brew"; then
        # Log the Homebrew installation
        if type log_info &>/dev/null; then
            log_info "Installing Homebrew"
        fi
        
        # Install Homebrew
        printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
        
        # Configure Homebrew paths based on architecture
        if [[ "$(uname -m)" == "arm64" ]]; then
            # Apple Silicon
            if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile"; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        else
            # Intel
            if ! grep -q 'eval "$(/usr/local/bin/brew shellenv)"' "$HOME/.zprofile"; then
                echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
        
        print_result $? "Homebrew installation"
        
        # Log the result
        if type log_info &>/dev/null; then
            if [ $? -eq 0 ]; then
                log_success "Homebrew installed successfully"
            else
                log_error "Failed to install Homebrew"
            fi
        fi
    else
        print_success "Homebrew is already installed"
        
        # Log that Homebrew is already installed
        if type log_info &>/dev/null; then
            log_info "Homebrew is already installed"
        fi
        
        # Update Homebrew
        #print_in_yellow "==> Updating Homebrew...\n"
        
        # Log the update
        if type log_info &>/dev/null; then
            log_info "Updating Homebrew"
        fi
        
        # Execute brew update with logging
        if type execute_with_log &>/dev/null; then
            execute_with_log "brew update" "Updating Homebrew"
        else
            brew update > /dev/null 2>&1
            print_result $? "Homebrew update"
        fi
    fi
}

configure_homebrew() {
    print_in_purple "\n   Configuring Homebrew\n\n"
    
    # Log the configuration
    if type log_info &>/dev/null; then
        log_info "Configuring Homebrew"
    fi

    # Opt-out of Homebrew's analytics
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew analytics off" "Disabling Homebrew analytics"
    else
        brew analytics off &> /dev/null
    fi

    # Note: The following taps have been deprecated as their contents
    # have been migrated to the main Homebrew repositories
    # No need to tap them explicitly anymore

    # Update Homebrew recipes
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew update" "Updating Homebrew recipes"
    else
        brew update &> /dev/null
        print_result $? "Homebrew recipes update"
    fi

    # Upgrade any already-installed formulae
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew upgrade" "Upgrading Homebrew formulae"
    else
        brew upgrade &> /dev/null
        print_result $? "Homebrew formulae upgrade"
    fi

    # Remove outdated versions from the cellar
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew cleanup" "Cleaning up Homebrew"
    else
        brew cleanup &> /dev/null
        print_result $? "Homebrew cleanup"
    fi
}

setup_homebrew_environment() {
    print_in_purple "\n   Setting up Homebrew environment\n\n"

    # Create Homebrew directories if they don't exist
    local -a BREW_DIRS=(
        "/opt/homebrew/etc"
        "/opt/homebrew/var"
        "/opt/homebrew/opt"
        "/opt/homebrew/share"
    )

    for dir in $BREW_DIRS; do
        if [[ ! -d "$dir" ]]; then
            sudo mkdir -p "$dir"
            sudo chown -R "$(whoami):admin" "$dir"
        fi
    done

    # Set Homebrew environment variables
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_INSECURE_REDIRECT=1
    export HOMEBREW_CASK_OPTS="--appdir=/Applications"
    
    print_result $? "Homebrew (environment setup)"
}

create_homebrew_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/homebrew.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Homebrew configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Homebrew configuration for zsh
# This file contains all Homebrew-related configurations
#

# Homebrew environment setup
if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # Intel
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Homebrew aliases
alias brewup="brew update && brew upgrade && brew cleanup"
alias brewls="brew list"
alias brewi="brew install"
alias brewci="brew install --cask"
alias brewrm="brew uninstall"
alias brewsr="brew search"
alias brewinfo="brew info"
alias brewdeps="brew deps --tree --installed"
alias brewdoc="brew doctor"
alias brewout="brew outdated"
EOL
    
    print_result $? "Created Homebrew configuration file"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "\n • Homebrew\n\n"
    
    # Log the main Homebrew setup
    if type log_info &>/dev/null; then
        log_info "Starting Homebrew setup"
    fi

    install_homebrew
    setup_homebrew_environment
    configure_homebrew
    
    # Create modular configuration
    create_homebrew_config

    # Check if oh-my-zsh.zsh is already sourcing the modular configs
    if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/homebrew.zsh\"" "$HOME/.zshrc"; then
        # Add a line to source the Homebrew config in .zshrc if oh-my-zsh.zsh isn't handling it
        cat >> "$HOME/.zshrc" << 'EOL'
# Load Homebrew configuration
source "$HOME/.jarvistoolset/zsh_configs/homebrew.zsh"
EOL
        print_result $? "Added Homebrew configuration to .zshrc"
    fi

    print_in_green "\n  Homebrew installed and configured!\n"
    
    # Log completion
    if type log_info &>/dev/null; then
        log_success "Homebrew setup completed"
    fi
}

main
