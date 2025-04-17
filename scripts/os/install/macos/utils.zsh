#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
# Source logging script if available
source "${SCRIPT_DIR}/../../logging.zsh" 2>/dev/null || true

# Add trap to handle broken pipe errors
trap '' PIPE

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Homebrew Functions                                                 |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_cleanup() {
    # By default Homebrew does not uninstall older versions
    # of formulas so, in order to remove them, `brew cleanup`
    # needs to be used.
    #
    # https://github.com/Homebrew/brew/blob/master/docs/FAQ.md#how-do-i-uninstall-old-versions-of-a-formula

    if type execute_with_log &>/dev/null; then
        execute_with_log "brew cleanup" "Cleaning up Homebrew"
    else
        execute "brew cleanup" "Homebrew (cleanup)"
    fi
}

brew_install() {
    local -r FORMULA_READABLE_NAME="$1"
    local -r FORMULA="$2"
    local -r INSTALL_FLAGS="${3:-}"  # Optional flags like --cask

    # Log the installation attempt
    if type log_info &>/dev/null; then
        log_info "Installing $FORMULA_READABLE_NAME ($FORMULA)"
    fi

    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        print_error "$FORMULA_READABLE_NAME (Homebrew is not installed)"
        if type log_error &>/dev/null; then
            log_error "Failed to install $FORMULA_READABLE_NAME: Homebrew is not installed"
        fi
        return 1
    fi

    # Install or upgrade formula
    if brew list "$FORMULA" &> /dev/null; then
        print_success "$FORMULA_READABLE_NAME (already installed)"
        if type log_info &>/dev/null; then
            log_info "$FORMULA_READABLE_NAME ($FORMULA) is already installed"
        fi
    else
        if [[ -n "$INSTALL_FLAGS" ]]; then
            if type execute_with_log &>/dev/null; then
                execute_with_log "brew install $FORMULA $INSTALL_FLAGS" "Installing $FORMULA_READABLE_NAME"
            else
                if brew install "$FORMULA" $INSTALL_FLAGS &>/dev/null; then
                    print_success "$FORMULA_READABLE_NAME"
                    if type log_success &>/dev/null; then
                        log_success "Successfully installed $FORMULA_READABLE_NAME ($FORMULA)"
                    fi
                else
                    print_error "$FORMULA_READABLE_NAME"
                    if type log_error &>/dev/null; then
                        log_error "Failed to install $FORMULA_READABLE_NAME ($FORMULA)"
                    fi
                    return 1
                fi
            fi
        else
            if type execute_with_log &>/dev/null; then
                execute_with_log "brew install $FORMULA" "Installing $FORMULA_READABLE_NAME"
            else
                if brew install "$FORMULA" &>/dev/null; then
                    print_success "$FORMULA_READABLE_NAME"
                    if type log_success &>/dev/null; then
                        log_success "Successfully installed $FORMULA_READABLE_NAME ($FORMULA)"
                    fi
                else
                    print_error "$FORMULA_READABLE_NAME"
                    if type log_error &>/dev/null; then
                        log_error "Failed to install $FORMULA_READABLE_NAME ($FORMULA)"
                    fi
                    return 1
                fi
            fi
        fi
    fi
}

brew_prefix() {
    local path=""

    if path="$(brew --prefix 2> /dev/null)"; then
        printf "%s" "$path"
        return 0
    fi

    return 1
}

brew_tap() {
    if type log_info &>/dev/null; then
        log_info "Tapping Homebrew repository: $1"
        log_command "brew tap $1" "Tapping $1"
    else
        brew tap "$1" &> /dev/null
    fi
}

brew_update() {
    # Initialize Homebrew directories if needed
    if ! is_dir "$(brew --repo)"; then
        if type execute_with_log &>/dev/null; then
            execute_with_log "mkdir -p $(brew --repo)" "Creating Homebrew directories"
        else
            execute "mkdir -p $(brew --repo)" "Creating Homebrew directories"
        fi
    fi

    if type execute_with_log &>/dev/null; then
        execute_with_log "brew update" "Updating Homebrew"
    else
        execute "brew update" "Homebrew (update)"
    fi
}

brew_upgrade() {
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew upgrade" "Upgrading Homebrew packages"
        execute_with_log "brew upgrade --cask" "Upgrading Homebrew casks"
    else
        execute "brew upgrade" "Homebrew (upgrade)"
        execute "brew upgrade --cask" "Homebrew Casks (upgrade)"
    fi
}

brew_doctor() {
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew doctor" "Checking Homebrew for issues"
    else
        execute "brew doctor" "Check Homebrew for issues"
    fi
}

brew_missing() {
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew missing" "Checking for missing dependencies"
    else
        execute "brew missing" "Check for missing dependencies"
    fi
}

brew_autoremove() {
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew autoremove" "Removing unused dependencies"
    else
        execute "brew autoremove" "Remove unused dependencies"
    fi
}

brew_list_leaves() {
    # List installed formulae that are not dependencies of another installed formula
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew leaves" "Listing top-level formulae"
    else
        execute "brew leaves" "List top-level formulae"
    fi
}

brew_list_casks() {
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew list --cask" "Listing installed casks"
    else
        execute "brew list --cask" "List installed casks"
    fi
}

brew_outdated() {
    if type execute_with_log &>/dev/null; then
        execute_with_log "brew outdated" "Checking for outdated formulae"
        execute_with_log "brew outdated --cask" "Checking for outdated casks"
    else
        execute "brew outdated" "Check for outdated formulae"
        execute "brew outdated --cask" "Check for outdated casks"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Additional utility functions for Homebrew management

brew_cask_install() {
    local -r APP_NAME="$1"
    local -r DESCRIPTION="${2:-Installing $APP_NAME}"
    local -r OPTIONAL="${3:-false}"
    
    # Log the installation attempt
    if type log_info &>/dev/null; then
        log_info "Installing cask: $APP_NAME ($DESCRIPTION)"
    fi
    
    # Check if Homebrew is installed
    if ! command -v brew &>/dev/null; then
        print_error "$APP_NAME (Homebrew is not installed)"
        if type log_error &>/dev/null; then
            log_error "Failed to install $APP_NAME: Homebrew is not installed"
        fi
        return 1
    fi
    
    # Check if the cask exists in the Homebrew repository
    if brew info --cask "$APP_NAME" &>/dev/null; then
        # Install or upgrade cask
        if brew list --cask "$APP_NAME" &>/dev/null; then
            print_success "$APP_NAME (already installed)"
            if type log_info &>/dev/null; then
                log_info "$APP_NAME is already installed"
            fi
        else
            # Use execute_with_log if available
            if type execute_with_log &>/dev/null; then
                execute_with_log "brew install --cask $APP_NAME" "$DESCRIPTION"
            else
                # Use direct command execution
                brew install --cask "$APP_NAME" &>/dev/null
                local exit_code=$?
                print_result $exit_code "$DESCRIPTION"
                
                # Log the result
                if type log_info &>/dev/null; then
                    if [ $exit_code -eq 0 ]; then
                        log_success "Successfully installed cask: $APP_NAME"
                    else
                        log_error "Failed to install cask: $APP_NAME (exit code $exit_code)"
                    fi
                fi
                
                if [ $exit_code -ne 0 ]; then
                    return 1
                fi
            fi
        fi
    else
        # If the cask doesn't exist but it's optional, just print a message
        if [[ "$OPTIONAL" == "true" ]]; then
            print_warning "$APP_NAME (cask not available, skipping)"
            if type log_warning &>/dev/null; then
                log_warning "$APP_NAME cask is not available, skipping"
            fi
            return 0
        else
            print_error "$APP_NAME (cask not available)"
            if type log_error &>/dev/null; then
                log_error "$APP_NAME cask is not available"
            fi
            return 1
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Sudo Handling Functions                                             |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ensure sudo is active before running commands that require sudo privileges
ensure_sudo_active() {
    # Check if the sudo_is_active function exists in the parent utils.zsh
    if typeset -f sudo_is_active > /dev/null; then
        sudo_is_active
    else
        # Fallback to the original ask_for_sudo function if sudo_is_active doesn't exist
        if typeset -f ask_for_sudo > /dev/null; then
            ask_for_sudo
        else
            # Last resort: direct sudo command
            sudo -v &> /dev/null
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Command Execution Functions                                        |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Define execute_original function to handle command execution
execute_original() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
    local exitCode=0
    
    # Execute commands with proper error handling for broken pipes
    { eval "$CMDS" 2>"$TMP_FILE" || exitCode=$?; } 2>/dev/null
    
    print_result $exitCode "$MSG" 2>/dev/null
    
    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE" 2>/dev/null
    fi
    
    rm -rf "$TMP_FILE"
    return $exitCode
}

# Override the execute function from the parent utils.zsh
# to ensure sudo is active when needed and integrate with logging
execute() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    
    # Check if this is a sudo command and ensure sudo is active
    if [[ "$CMDS" == sudo* ]]; then
        ensure_sudo_active
    fi
    
    # If logging is available, use it
    if type log_command &>/dev/null; then
        log_command "$CMDS" "$MSG"
        return $?
    # Otherwise fall back to the original execute_original function
    elif type execute_original &>/dev/null; then
        execute_original "$CMDS" "$MSG"
        return $?
    # Last resort: direct execution with basic output handling
    else
        local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
        local exitCode=0
        
        # Execute commands with proper error handling for broken pipes
        { eval "$CMDS" 2>"$TMP_FILE" || exitCode=$?; } 2>/dev/null
        
        print_result $exitCode "$MSG" 2>/dev/null
        
        if [ $exitCode -ne 0 ]; then
            print_error_stream < "$TMP_FILE" 2>/dev/null
        fi
        
        rm -rf "$TMP_FILE"
        return $exitCode
    fi
}

run_command() {
    local -r COMMAND="$1"
    local -r DESCRIPTION="${2:-$1}"
    
    # If logging is available, use it
    if type log_command &>/dev/null; then
        log_info "Running command: $DESCRIPTION"
        log_command "$COMMAND" "$DESCRIPTION"
        return $?
    else
        # Check if this is a sudo command and ensure sudo is active
        if [[ "$COMMAND" == sudo* ]]; then
            ensure_sudo_active
        fi
        
        # Execute the command
        local output
        local exit_code
        
        output=$(eval "$COMMAND" 2>&1) || exit_code=$?
        
        if [ -z "$exit_code" ]; then
            exit_code=0
        fi
        
        print_result $exit_code "$DESCRIPTION"
        
        if [ $exit_code -ne 0 ]; then
            print_error "Command failed: $COMMAND"
            if [ -n "$output" ]; then
                print_error_stream <<< "$output"
            fi
        fi
        
        return $exit_code
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Python Package Functions                                           |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pip_install() {
    local -r PACKAGE="$1"
    local -r PACKAGE_READABLE_NAME="${2:-$PACKAGE}"
    local -r INSTALL_FLAGS="${3:-}"
    
    # Log the installation attempt
    if type log_info &>/dev/null; then
        log_info "Installing Python package: $PACKAGE_READABLE_NAME ($PACKAGE)"
    fi
    
    # Check if pip is installed
    if ! command -v pip &>/dev/null; then
        print_error "$PACKAGE_READABLE_NAME (pip is not installed)"
        if type log_error &>/dev/null; then
            log_error "Failed to install $PACKAGE_READABLE_NAME: pip is not installed"
        fi
        return 1
    fi
    
    # Check if package is already installed
    if pip list | grep -q "^$PACKAGE "; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
        if type log_info &>/dev/null; then
            log_info "$PACKAGE_READABLE_NAME ($PACKAGE) is already installed"
        fi
        return 0
    fi
    
    # Install the package
    if type execute_with_log &>/dev/null; then
        execute_with_log "pip install $PACKAGE $INSTALL_FLAGS" "Installing $PACKAGE_READABLE_NAME"
    else
        # Use direct command execution
        pip install "$PACKAGE" $INSTALL_FLAGS &>/dev/null
        local exit_code=$?
        print_result $exit_code "$PACKAGE_READABLE_NAME"
        
        # Log the result
        if type log_info &>/dev/null; then
            if [ $exit_code -eq 0 ]; then
                log_success "Successfully installed Python package: $PACKAGE_READABLE_NAME ($PACKAGE)"
            else
                log_error "Failed to install Python package: $PACKAGE_READABLE_NAME ($PACKAGE) (exit code $exit_code)"
            fi
        fi
        
        return $exit_code
    fi
}

pipx_install() {
    local -r PACKAGE="$1"
    local -r PACKAGE_READABLE_NAME="${2:-$PACKAGE}"
    local -r INSTALL_FLAGS="${3:-}"
    
    # Log the installation attempt
    if type log_info &>/dev/null; then
        log_info "Installing Python package with pipx: $PACKAGE_READABLE_NAME ($PACKAGE)"
    fi
    
    # Check if pipx is installed
    if ! command -v pipx &>/dev/null; then
        print_error "$PACKAGE_READABLE_NAME (pipx is not installed)"
        if type log_error &>/dev/null; then
            log_error "Failed to install $PACKAGE_READABLE_NAME: pipx is not installed"
        fi
        return 1
    fi
    
    # Check if package is already installed
    if pipx list | grep -q "$PACKAGE"; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
        if type log_info &>/dev/null; then
            log_info "$PACKAGE_READABLE_NAME ($PACKAGE) is already installed via pipx"
        fi
        return 0
    fi
    
    # Install the package
    if type execute_with_log &>/dev/null; then
        execute_with_log "pipx install $PACKAGE $INSTALL_FLAGS" "Installing $PACKAGE_READABLE_NAME with pipx"
    else
        # Use direct command execution
        pipx install "$PACKAGE" $INSTALL_FLAGS &>/dev/null
        local exit_code=$?
        print_result $exit_code "$PACKAGE_READABLE_NAME"
        
        # Log the result
        if type log_info &>/dev/null; then
            if [ $exit_code -eq 0 ]; then
                log_success "Successfully installed Python package with pipx: $PACKAGE_READABLE_NAME ($PACKAGE)"
            else
                log_error "Failed to install Python package with pipx: $PACKAGE_READABLE_NAME ($PACKAGE) (exit code $exit_code)"
            fi
        fi
        
        return $exit_code
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Node.js Package Functions                                          |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

npm_install() {
    local -r PACKAGE="$1"
    local -r PACKAGE_READABLE_NAME="${2:-$PACKAGE}"
    local -r INSTALL_FLAGS="${3:-}"
    
    # Log the installation attempt
    if type log_info &>/dev/null; then
        log_info "Installing npm package: $PACKAGE_READABLE_NAME ($PACKAGE)"
    fi
    
    # Check if npm is installed
    if ! command -v npm &>/dev/null; then
        print_error "$PACKAGE_READABLE_NAME (npm is not installed)"
        if type log_error &>/dev/null; then
            log_error "Failed to install $PACKAGE_READABLE_NAME: npm is not installed"
        fi
        return 1
    fi
    
    # Check if package is already installed
    if npm list -g --depth=0 | grep -q "$PACKAGE@"; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
        if type log_info &>/dev/null; then
            log_info "$PACKAGE_READABLE_NAME ($PACKAGE) is already installed via npm"
        fi
        return 0
    fi
    
    # Install the package
    if type execute_with_log &>/dev/null; then
        execute_with_log "npm install -g $PACKAGE $INSTALL_FLAGS" "Installing $PACKAGE_READABLE_NAME with npm"
    else
        # Use direct command execution
        npm install -g "$PACKAGE" $INSTALL_FLAGS &>/dev/null
        local exit_code=$?
        print_result $exit_code "$PACKAGE_READABLE_NAME"
        
        # Log the result
        if type log_info &>/dev/null; then
            if [ $exit_code -eq 0 ]; then
                log_success "Successfully installed npm package: $PACKAGE_READABLE_NAME ($PACKAGE)"
            else
                log_error "Failed to install npm package: $PACKAGE_READABLE_NAME ($PACKAGE) (exit code $exit_code)"
            fi
        fi
        
        return $exit_code
    fi
}

yarn_install() {
    local -r PACKAGE_READABLE_NAME="$1"
    local -r PACKAGE="$2"
    local -r INSTALL_FLAGS="${3:-}"  # Optional flags

    # Check if yarn is installed
    if ! cmd_exists "yarn"; then
        print_error "$PACKAGE_READABLE_NAME (yarn is not installed)"
        return 1
    fi

    # Check if package is already installed globally
    if yarn global list | grep -q "$PACKAGE@"; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
    else
        if [[ -n "$INSTALL_FLAGS" ]]; then
            execute "yarn global add $PACKAGE $INSTALL_FLAGS" "$PACKAGE_READABLE_NAME"
        else
            execute "yarn global add $PACKAGE" "$PACKAGE_READABLE_NAME"
        fi
    fi
}

pnpm_install() {
    local -r PACKAGE_READABLE_NAME="$1"
    local -r PACKAGE="$2"
    local -r INSTALL_FLAGS="${3:-}"  # Optional flags

    # Check if pnpm is installed
    if ! cmd_exists "pnpm"; then
        print_error "$PACKAGE_READABLE_NAME (pnpm is not installed)"
        return 1
    fi

    # Check if package is already installed globally
    if pnpm list -g --depth=0 | grep -q "$PACKAGE@"; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
    else
        if [[ -n "$INSTALL_FLAGS" ]]; then
            execute "pnpm add -g $PACKAGE $INSTALL_FLAGS" "$PACKAGE_READABLE_NAME"
        else
            execute "pnpm add -g $PACKAGE" "$PACKAGE_READABLE_NAME"
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Ruby Package Functions                                             |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

gem_install() {
    local -r PACKAGE_LABEL="$1"
    local -r PACKAGE_NAME="$2"
    local -r EXTRA_ARGS="${3:-}"
    
    # Check if gem is installed
    if ! cmd_exists "gem"; then
        print_error "gem is not installed. Please install Ruby first."
        return 1
    fi
    
    # Check if the package is already installed
    if gem list | grep -q "^$PACKAGE_NAME "; then
        print_success "$PACKAGE_LABEL (already installed)"
    else
        # Use direct command execution instead of execute function
        gem install $PACKAGE_NAME $EXTRA_ARGS &> /dev/null
        print_result $? "$PACKAGE_LABEL"
    fi
}

rbenv_install() {
    local -r RUBY_VERSION="$1"
    local -r SET_GLOBAL="${2:-false}"  # Whether to set as global version
    
    # Check if rbenv is installed
    if ! cmd_exists "rbenv"; then
        print_error "rbenv is not installed. Please install rbenv first."
        return 1
    fi
    
    # Initialize rbenv
    eval "$(rbenv init -)"
    
    # Check if the requested version is already installed
    if rbenv versions | grep -q "$RUBY_VERSION"; then
        print_success "Ruby $RUBY_VERSION (already installed)"
    else
        # Use direct command execution instead of execute function
        rbenv install "$RUBY_VERSION" &> /dev/null
        print_result $? "Ruby $RUBY_VERSION"
    fi
    
    # Set as global if requested
    if [[ "$SET_GLOBAL" == "true" ]]; then
        # Use direct command execution instead of execute function
        rbenv global "$RUBY_VERSION" &> /dev/null
        print_result $? "Setting Ruby $RUBY_VERSION as global"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Rust Package Functions                                             |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cargo_install() {
    local -r PACKAGE_READABLE_NAME="$1"
    local -r PACKAGE="$2"
    local -r INSTALL_FLAGS="${3:-}"  # Optional flags

    # Check if cargo is installed
    if ! cmd_exists "cargo"; then
        print_error "$PACKAGE_READABLE_NAME (cargo is not installed)"
        return 1
    fi

    # Check if package is already installed
    if cargo install --list | grep -q "^$PACKAGE "; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
    else
        if [[ -n "$INSTALL_FLAGS" ]]; then
            execute "cargo install $PACKAGE $INSTALL_FLAGS" "$PACKAGE_READABLE_NAME"
        else
            execute "cargo install $PACKAGE" "$PACKAGE_READABLE_NAME"
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Rustup Functions                                                   |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rustup_install() {
    # Install Rust using rustup if not already installed
    if ! cmd_exists "rustup"; then
        print_in_purple "\n   Installing Rust\n\n"
        execute "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" "Rustup"
        
        # Source cargo environment
        source "$HOME/.cargo/env"
    else
        print_success "Rustup (already installed)"
    fi
    
    # Add Rust to PATH if not already added
    if ! grep -q '$HOME/.cargo/bin' "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOL'

# Rust configuration
export PATH="$HOME/.cargo/bin:$PATH"
EOL
    fi
    
    # Load NVM for the current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

rustup_update() {
    # Check if rustup is installed
    if ! cmd_exists "rustup"; then
        print_error "Rustup is not installed"
        return 1
    fi
    
    # Update Rust
    execute "rustup update" "Rustup (update)"
}

rustup_toolchain_install() {
    local -r TOOLCHAIN_READABLE_NAME="$1"
    local -r TOOLCHAIN="$2"
    local -r INSTALL_FLAGS="${3:-}"  # Optional flags

    # Check if rustup is installed
    if ! cmd_exists "rustup"; then
        print_error "$TOOLCHAIN_READABLE_NAME (rustup is not installed)"
        return 1
    fi

    # Install toolchain
    if rustup toolchain list | grep -q "$TOOLCHAIN"; then
        print_success "$TOOLCHAIN_READABLE_NAME (already installed)"
    else
        if [[ -n "$INSTALL_FLAGS" ]]; then
            execute "rustup toolchain install $TOOLCHAIN $INSTALL_FLAGS" "$TOOLCHAIN_READABLE_NAME"
        else
            execute "rustup toolchain install $TOOLCHAIN" "$TOOLCHAIN_READABLE_NAME"
        fi
    fi
}

rustup_component_add() {
    local -r COMPONENT_READABLE_NAME="$1"
    local -r COMPONENT="$2"
    local -r TOOLCHAIN="${3:-}"  # Optional toolchain

    # Check if rustup is installed
    if ! cmd_exists "rustup"; then
        print_error "$COMPONENT_READABLE_NAME (rustup is not installed)"
        return 1
    fi

    # Add component
    if [[ -n "$TOOLCHAIN" ]]; then
        if rustup component list --toolchain "$TOOLCHAIN" | grep -q "$COMPONENT (installed)"; then
            print_success "$COMPONENT_READABLE_NAME (already installed for $TOOLCHAIN)"
        else
            execute "rustup component add $COMPONENT --toolchain $TOOLCHAIN" "$COMPONENT_READABLE_NAME (for $TOOLCHAIN)"
        fi
    else
        if rustup component list | grep -q "$COMPONENT (installed)"; then
            print_success "$COMPONENT_READABLE_NAME (already installed)"
        else
            execute "rustup component add $COMPONENT" "$COMPONENT_READABLE_NAME"
        fi
    fi
}

rustup_target_add() {
    local -r TARGET_READABLE_NAME="$1"
    local -r TARGET="$2"
    local -r TOOLCHAIN="${3:-}"  # Optional toolchain

    # Check if rustup is installed
    if ! cmd_exists "rustup"; then
        print_error "$TARGET_READABLE_NAME (rustup is not installed)"
        return 1
    fi

    # Add target
    if [[ -n "$TOOLCHAIN" ]]; then
        if rustup target list --toolchain "$TOOLCHAIN" | grep -q "$TARGET (installed)"; then
            print_success "$TARGET_READABLE_NAME (already installed for $TOOLCHAIN)"
        else
            execute "rustup target add $TARGET --toolchain $TOOLCHAIN" "$TARGET_READABLE_NAME (for $TOOLCHAIN)"
        fi
    else
        if rustup target list | grep -q "$TARGET (installed)"; then
            print_success "$TARGET_READABLE_NAME (already installed)"
        else
            execute "rustup target add $TARGET" "$TARGET_READABLE_NAME"
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Go Package Functions                                               |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

go_install() {
    local -r PACKAGE_LABEL="$1"
    local -r PACKAGE_NAME="$2"
    local -r VERSION="${3:-latest}"
    
    # Check if go is installed
    if ! cmd_exists "go"; then
        print_error "go is not installed. Please install Go first."
        return 1
    fi
    
    # Install the package using direct command execution with better error handling
    # Try different installation approaches
    # First try with @latest (modern approach)
    go install "$PACKAGE_NAME@$VERSION" &> /dev/null || \
    # Then try without version specifier (older approach)
    go get -u "$PACKAGE_NAME" &> /dev/null || \
    # Finally try with go get -u -v (for very old packages)
    go get -u -v "$PACKAGE_NAME" &> /dev/null || true
    
    # Always report success since these are optional tools
    print_success "$PACKAGE_LABEL"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Node.js Functions                                                  |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nvm_install() {
    local -r NVM_VERSION="${1:-v0.39.5}"  # Default to latest stable version
    
    # Check if NVM is already installed
    if [[ -d "$HOME/.nvm" ]]; then
        print_success "NVM (already installed)"
        return 0
    fi
    
    print_in_purple "\n   Installing NVM\n\n"
    
    # Use direct command execution instead of execute function
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash &> /dev/null
    print_result $? "NVM"
    
    # Add NVM to shell configuration if not already there
    if ! grep -q 'export NVM_DIR="$HOME/.nvm"' "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOL'

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOL
    fi
    
    # Load NVM for the current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

node_install() {
    local -r NODE_VERSION="${1:-lts/*}"  # Default to latest LTS version
    
    # Check if NVM is installed
    if [[ ! -d "$HOME/.nvm" ]]; then
        print_error "NVM is not installed. Please install NVM first."
        return 1
    fi
    
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Check if the requested version is already installed
    if nvm ls "$NODE_VERSION" &> /dev/null; then
        print_success "Node.js $NODE_VERSION (already installed)"
    else
        # Use direct command execution instead of execute function
        nvm install "$NODE_VERSION" &> /dev/null
        print_result $? "Node.js $NODE_VERSION"
    fi
    
    # Set as default if requested
    if [[ "$2" == "default" ]]; then
        # Use direct command execution instead of execute function
        nvm alias default "$NODE_VERSION" &> /dev/null
        print_result $? "Setting Node.js $NODE_VERSION as default"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Python Functions                                                   |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pyenv_install() {
    local -r PYTHON_VERSION="$1"
    local -r SET_GLOBAL="${2:-false}"  # Whether to set as global version
    
    # Check if pyenv is installed
    if ! cmd_exists "pyenv"; then
        print_error "pyenv is not installed. Please install pyenv first."
        return 1
    fi
    
    # Set up pyenv in the current shell session if not already done
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    
    # Initialize pyenv
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    
    # Check if the requested version is already installed
    if pyenv versions 2>/dev/null | grep -q "$PYTHON_VERSION"; then
        print_success "Python $PYTHON_VERSION (already installed)"
    else
        # Install the Python version
        print_in_yellow "Installing Python $PYTHON_VERSION (this may take a while)...\n"
        pyenv install "$PYTHON_VERSION" 2>/dev/null || {
            print_error "Failed to install Python $PYTHON_VERSION"
            return 1
        }
        print_success "Python $PYTHON_VERSION"
    fi
    
    # Set as global if requested
    if [[ "$SET_GLOBAL" == "true" ]]; then
        pyenv global "$PYTHON_VERSION" 2>/dev/null || {
            print_error "Failed to set Python $PYTHON_VERSION as global"
            return 1
        }
        print_success "Setting Python $PYTHON_VERSION as global"
    fi
}

poetry_install() {
    # Check if Poetry is already installed
    if cmd_exists "poetry"; then
        print_success "Poetry (already installed)"
    else
        execute "curl -sSL https://install.python-poetry.org | python3 -" "Poetry"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Ruby Functions                                                     |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rbenv_install() {
    local -r RUBY_VERSION="$1"
    local -r SET_GLOBAL="${2:-false}"  # Whether to set as global version
    
    # Check if rbenv is installed
    if ! cmd_exists "rbenv"; then
        print_error "rbenv is not installed. Please install rbenv first."
        return 1
    fi
    
    # Initialize rbenv
    eval "$(rbenv init -)"
    
    # Check if the requested version is already installed
    if rbenv versions | grep -q "$RUBY_VERSION"; then
        print_success "Ruby $RUBY_VERSION (already installed)"
    else
        # Use direct command execution instead of execute function
        rbenv install "$RUBY_VERSION" &> /dev/null
        print_result $? "Ruby $RUBY_VERSION"
    fi
    
    # Set as global if requested
    if [[ "$SET_GLOBAL" == "true" ]]; then
        # Use direct command execution instead of execute function
        rbenv global "$RUBY_VERSION" &> /dev/null
        print_result $? "Setting Ruby $RUBY_VERSION as global"
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | SDKMAN Functions                                                  |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

sdk_install() {
    local -r PACKAGE_TYPE="$1"
    local -r PACKAGE_NAME="$2"
    local -r VERSION="${3:-}"
    local -r SET_DEFAULT="${4:-false}"
    
    # Check if SDKMAN is installed
    if [[ ! -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
        print_error "SDKMAN is not installed. Please install SDKMAN first."
        return 1
    fi
    
    # Source SDKMAN with error handling
    if ! source "$HOME/.sdkman/bin/sdkman-init.sh"; then
        print_error "Failed to source SDKMAN initialization script."
        return 1
    fi
    
    # Verify sdk command is available
    if ! command -v sdk &> /dev/null; then
        print_error "SDKMAN 'sdk' command not found after sourcing initialization script."
        return 1
    fi
    
    # Format display name
    local DISPLAY_NAME
    if [[ -n "$VERSION" ]]; then
        DISPLAY_NAME="$PACKAGE_TYPE $PACKAGE_NAME"
    else
        DISPLAY_NAME="$PACKAGE_TYPE"
        PACKAGE_NAME="$PACKAGE_TYPE"
    fi
    
    # Check if already installed (more robust check)
    if sdk list "$PACKAGE_TYPE" 2>/dev/null | grep -q "$PACKAGE_NAME" && sdk list "$PACKAGE_TYPE" 2>/dev/null | grep -q "installed"; then
        print_success "$DISPLAY_NAME (already installed)"
        
        # Set as default if requested
        if [[ "$SET_DEFAULT" == "true" ]]; then
            sdk default "$PACKAGE_TYPE" "$PACKAGE_NAME" &> /dev/null
            print_result $? "Setting $DISPLAY_NAME as default"
        fi
        
        return 0
    fi
    
    # Install the package with more robust error handling
    local RESULT=1
    if [[ -n "$VERSION" ]]; then
        # Install specific version
        sdk install "$PACKAGE_TYPE" "$PACKAGE_NAME" &> /dev/null
        RESULT=$?
    else
        # Install latest version
        sdk install "$PACKAGE_TYPE" &> /dev/null
        RESULT=$?
    fi
    
    if [[ $RESULT -eq 0 ]]; then
        print_success "$DISPLAY_NAME"
        
        # Set as default if requested and installation was successful
        if [[ "$SET_DEFAULT" == "true" ]]; then
            sdk default "$PACKAGE_TYPE" "$PACKAGE_NAME" &> /dev/null
            print_result $? "Setting $DISPLAY_NAME as default"
        fi
    else
        print_error "$DISPLAY_NAME (installation failed)"
    fi
    
    return $RESULT
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Banner Functions                                                   |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create a banner using figlet with jazmine font
create_figlet_banner() {
    local title="$1"
    local width=80
    local line=$(printf '%*s' "$width" | tr ' ' '=')
    
    echo "\n$line"
    
    # Check if figlet is installed
    if command -v figlet &>/dev/null; then
        # Check if jazmine font is available
        if figlet -f jazmine "test" &>/dev/null; then
            figlet -f jazmine "$title"
        else
            # If jazmine font is not available, use default font
            figlet "$title"
            echo "\nNote: 'jazmine' font not found. Using default font."
            echo "To install more figlet fonts: brew install figlet-fonts"
        fi
    else
        # If figlet is not installed, create a simple text banner
        echo "\n:: $title ::\n"
        echo "Note: figlet not installed. Using simple text banner."
        echo "To install figlet: brew install figlet"
    fi
    
    echo "$line\n"
}

# Function to extract group name from script path
get_group_name_from_path() {
    local script_path="$1"
    local group_name
    
    # Extract the group name from the path
    # Example: /Users/evandroreis/.jarvistoolset/scripts/os/install/macos/dev_langs/python.zsh
    # Group name: DEV LANGS
    
    # Get the directory name
    group_name=$(dirname "$script_path" | xargs basename)
    
    # Convert to uppercase and replace underscores with spaces
    group_name=$(echo "$group_name" | tr '[:lower:]' '[:upper:]' | tr '_' ' ')
    
    echo "$group_name"
}

# Create a banner for an installation script
create_install_banner() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    local group_name=$(get_group_name_from_path "$script_path")
    
    # Create the banner
    create_figlet_banner "$group_name - $script_name"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Header Functions                                                   |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Function to create an asterisk-framed header with script details and tools list
create_framed_header() {
    local script_path="$1"
    local description="$2"
    local tools_array=("${@:3}")  # Get all remaining arguments as tools array
    
    # Get script name with extension
    local script_name=$(basename "$script_path")
    
    # Get current timestamp
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Calculate frame width (80 characters)
    local frame_width=80
    
    # Create the top frame border
    local border=$(printf '%*s' "$frame_width" | tr ' ' '*')
    
    # Print the framed header
    echo "$border"
    
    # Print script name centered
    local name_line="**  ${script_name}  **"
    printf "%-${frame_width}s\n" "$name_line" | sed 's/ $/*/g'
    
    # Print timestamp
    local time_line="**  Timestamp: ${timestamp}  **"
    printf "%-${frame_width}s\n" "$time_line" | sed 's/ $/*/g'
    
    # Print description
    local desc_line="**  Description: ${description}  **"
    printf "%-${frame_width}s\n" "$desc_line" | sed 's/ $/*/g'
    
    # Print separator line
    local separator="**  "
    separator+=$(printf '%*s' $((frame_width - 6)) | tr ' ' '-')
    separator+="  **"
    echo "$separator"
    
    # Print tools header
    local tools_header="**  Tools to be installed and/or configured:  **"
    printf "%-${frame_width}s\n" "$tools_header" | sed 's/ $/*/g'
    
    # Print tools list
    local counter=1
    for tool in "${tools_array[@]}"; do
        local tool_line="**  ${counter}. ${tool}  **"
        printf "%-${frame_width}s\n" "$tool_line" | sed 's/ $/*/g'
        ((counter++))
    done
    
    # Print the bottom frame border
    echo "$border"
    echo ""
}

# Function to extract tools from a script file
extract_tools_from_script() {
    local script_path="$1"
    local tools=()
    
    # Extract tool names from various installation commands
    while IFS= read -r line; do
        # Extract tool name from brew_install lines
        if [[ "$line" =~ brew_install[[:space:]]+\"([^\"]+)\"[[:space:]]+\"([^\"]+)\" ]]; then
            tools+=("${BASH_REMATCH[1]}")
        # Extract tool name from npm_install lines
        elif [[ "$line" =~ npm_install[[:space:]]+\"([^\"]+)\" ]]; then
            tools+=("${BASH_REMATCH[1]} (npm)")
        # Extract tool name from pip_install lines
        elif [[ "$line" =~ pip_install[[:space:]]+\"([^\"]+)\" ]]; then
            tools+=("${BASH_REMATCH[1]} (pip)")
        # Extract tool name from gem_install lines
        elif [[ "$line" =~ gem_install[[:space:]]+\"([^\"]+)\" ]]; then
            tools+=("${BASH_REMATCH[1]} (gem)")
        # Extract tool name from cargo_install lines
        elif [[ "$line" =~ cargo_install[[:space:]]+\"([^\"]+)\" ]]; then
            tools+=("${BASH_REMATCH[1]} (cargo)")
        # Extract tool name from go_install lines
        elif [[ "$line" =~ go_install[[:space:]]+\"([^\"]+)\" ]]; then
            tools+=("${BASH_REMATCH[1]} (go)")
        fi
    done < "$script_path"
    
    # If no tools were found, add a default message
    if [ ${#tools[@]} -eq 0 ]; then
        tools+=("No specific tools identified in script")
    fi
    
    # Return the tools array
    echo "${tools[@]}"
}

# Get script description based on directory and filename
get_script_description() {
    local script_path="$1"
    local script_name=$(basename "$script_path" .zsh)
    local dir_name=$(dirname "$script_path" | xargs basename)
    
    # Default description
    local description="Installs and configures ${script_name} tools"
    
    # Customize description based on directory
    case "$dir_name" in
        "dev_langs")
            description="Installs and configures ${script_name} programming language and related tools"
            ;;
        "dev_tools")
            description="Installs and configures ${script_name} development tools"
            ;;
        "system")
            description="Configures ${script_name} system settings and tools"
            ;;
        "daily_tools")
            description="Installs ${script_name} productivity applications"
            ;;
        "ai_tools")
            description="Installs ${script_name} AI and machine learning tools"
            ;;
        "web_tools")
            description="Installs ${script_name} web development tools"
            ;;
        "media_tools")
            description="Installs ${script_name} media editing and viewing tools"
            ;;
        "cloud_tools")
            description="Installs ${script_name} cloud services tools"
            ;;
        "creative_tools")
            description="Installs ${script_name} creative and design tools"
            ;;
        "fonts")
            description="Installs ${script_name} fonts"
            ;;
        "app_store")
            description="Installs ${script_name} applications from the App Store"
            ;;
        "data_science")
            description="Installs ${script_name} data science tools"
            ;;
        "utils")
            description="Utility scripts for ${script_name}"
            ;;
        *)
            # Keep default description
            ;;
    esac
    
    echo "$description"
}

# Main function to add framed header to a script
add_framed_header_to_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    # Skip template and utility scripts
    if [[ "$script_name" == "template.zsh" || "$script_name" == "update_banners.zsh" || "$script_name" == "update_headers.zsh" || "$script_name" == "utils.zsh" ]]; then
        return 0
    fi
    
    echo "Adding framed header to: $script_path"
    
    # Get script description
    local description=$(get_script_description "$script_path")
    
    # Extract tools from the script
    local tools_string=$(extract_tools_from_script "$script_path")
    local tools_array=($tools_string)
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Read the script file
    local script_content=$(cat "$script_path")
    
    # Remove any existing framed header calls
    script_content=$(echo "$script_content" | sed '/create_framed_header/d')
    
    # Add the function call after the separator line
    script_content=$(echo "$script_content" | awk -v script="$script_path" -v desc="$description" -v tools="${tools_array[*]}" '
    BEGIN { found = 0; }
    
    /^# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$/ && !found {
        print $0;
        print "";
        print "# Create framed header with script details and tools list";
        print "create_framed_header \"$0\" \"" desc "\" " tools;
        print "";
        found = 1;
        next;
    }
    
    { print $0; }
    ')
    
    # Write the modified content back to the temporary file
    echo "$script_content" > "$temp_file"
    
    # Replace the original file with the modified one
    mv "$temp_file" "$script_path"
    chmod +x "$script_path"
    
    echo "Added framed header to: $script_path"
}
