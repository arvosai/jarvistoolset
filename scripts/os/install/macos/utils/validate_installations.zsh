#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"
source "${SCRIPT_DIR}/../../logging.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Validating Tool Installations

"
log_info "Starting validation of installed tools"

# Function to check if a command exists
check_command() {
    local cmd="$1"
    local name="${2:-$1}"
    
    if command -v "$cmd" &>/dev/null; then
        print_success "$name is installed"
        log_info "$name is installed"
        return 0
    else
        print_error "$name is not installed"
        log_error "$name is not installed"
        return 1
    fi
}

# Function to check if a Homebrew formula is installed
check_brew_formula() {
    local formula="$1"
    local name="${2:-$formula}"
    
    if brew list "$formula" &>/dev/null; then
        print_success "$name is installed"
        log_info "$name is installed"
        return 0
    else
        print_error "$name is not installed"
        log_error "$name is not installed"
        return 1
    fi
}

# Function to check if a Python package is installed
check_pip_package() {
    local package="$1"
    local name="${2:-$package}"
    
    if pip show "$package" &>/dev/null; then
        print_success "$name is installed"
        log_info "$name is installed"
        return 0
    else
        print_error "$name is not installed"
        log_error "$name is not installed"
        return 1
    fi
}

# Function to check if a Node.js package is installed
check_npm_package() {
    local package="$1"
    local name="${2:-$package}"
    local global="${3:-true}"
    
    if [[ "$global" == "true" ]]; then
        if npm list -g "$package" &>/dev/null; then
            print_success "$name is installed"
            log_info "$name is installed"
            return 0
        else
            print_error "$name is not installed"
            log_error "$name is not installed"
            return 1
        fi
    else
        if npm list "$package" &>/dev/null; then
            print_success "$name is installed"
            log_info "$name is installed"
            return 0
        else
            print_error "$name is not installed"
            log_error "$name is not installed"
            return 1
        fi
    fi
}

# Validate System Setup tools
validate_system_setup() {
    print_in_purple "
   Validating System Setup Tools

"
    log_info "Validating System Setup Tools"
    
    # Check Homebrew
    check_command "brew" "Homebrew"
    
    # Check Oh My Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh is installed"
        log_info "Oh My Zsh is installed"
    else
        print_error "Oh My Zsh is not installed"
        log_error "Oh My Zsh is not installed"
    fi
    
    # Check Xcode Command Line Tools
    if xcode-select -p &>/dev/null; then
        print_success "Xcode Command Line Tools are installed"
        log_info "Xcode Command Line Tools are installed"
    else
        print_error "Xcode Command Line Tools are not installed"
        log_error "Xcode Command Line Tools are not installed"
    fi
}

# Validate Development Languages
validate_dev_langs() {
    print_in_purple "
   Validating Development Languages

"
    log_info "Validating Development Languages"
    
    # Check Python
    check_command "python3" "Python"
    
    # Check Node.js
    check_command "node" "Node.js"
    
    # Check Ruby
    check_command "ruby" "Ruby"
    
    # Check Go
    check_command "go" "Go"
    
    # Check Rust
    check_command "rustc" "Rust"
    check_command "cargo" "Cargo"
    
    # Check Java
    check_command "java" "Java"
    
    # Check Kotlin
    check_command "kotlin" "Kotlin"
    
    # Check Swift
    check_command "swift" "Swift"
    
    # Check PHP
    check_command "php" "PHP"
    
    # Check C/C++
    check_command "gcc" "GCC"
    check_command "g++" "G++"
    check_command "clang" "Clang"
}

# Validate AI and ML Tools
validate_ai_ml() {
    print_in_purple "
   Validating AI and ML Tools

"
    log_info "Validating AI and ML Tools"
    
    # Check TensorFlow
    check_pip_package "tensorflow" "TensorFlow"
    
    # Check PyTorch
    check_pip_package "torch" "PyTorch"
    
    # Check Jupyter
    check_command "jupyter" "Jupyter"
    
    # Check scikit-learn
    check_pip_package "scikit-learn" "scikit-learn"
    
    # Check pandas
    check_pip_package "pandas" "pandas"
    
    # Check matplotlib
    check_pip_package "matplotlib" "matplotlib"
}

# Validate Development Tools
validate_dev_tools() {
    print_in_purple "
   Validating Development Tools

"
    log_info "Validating Development Tools"
    
    # Check Git
    check_command "git" "Git"
    
    # Check Docker
    check_command "docker" "Docker"
    
    # Check VS Code
    check_command "code" "Visual Studio Code"
    
    # Check JetBrains Toolbox
    if [[ -d "/Applications/JetBrains Toolbox.app" ]]; then
        print_success "JetBrains Toolbox is installed"
        log_info "JetBrains Toolbox is installed"
    else
        print_error "JetBrains Toolbox is not installed"
        log_error "JetBrains Toolbox is not installed"
    fi
    
    # Check Sublime Text
    if [[ -d "/Applications/Sublime Text.app" ]]; then
        print_success "Sublime Text is installed"
        log_info "Sublime Text is installed"
    else
        print_error "Sublime Text is not installed"
        log_error "Sublime Text is not installed"
    fi
    
    # Check Atom
    if [[ -d "/Applications/Atom.app" ]]; then
        print_success "Atom is installed"
        log_info "Atom is installed"
    else
        print_error "Atom is not installed"
        log_error "Atom is not installed"
    fi
    
    # Check Yarn
    check_command "yarn" "Yarn"
}

# Validate Productivity Tools
validate_productivity() {
    print_in_purple "
   Validating Productivity Tools

"
    log_info "Validating Productivity Tools"
    
    # Check Alfred
    if [[ -d "/Applications/Alfred 4.app" ]]; then
        print_success "Alfred is installed"
        log_info "Alfred is installed"
    else
        print_error "Alfred is not installed"
        log_error "Alfred is not installed"
    fi
    
    # Check Rectangle
    if [[ -d "/Applications/Rectangle.app" ]]; then
        print_success "Rectangle is installed"
        log_info "Rectangle is installed"
    else
        print_error "Rectangle is not installed"
        log_error "Rectangle is not installed"
    fi
    
    # Check Notion
    if [[ -d "/Applications/Notion.app" ]]; then
        print_success "Notion is installed"
        log_info "Notion is installed"
    else
        print_error "Notion is not installed"
        log_error "Notion is not installed"
    fi
    
    # Check 1Password
    if [[ -d "/Applications/1Password.app" ]]; then
        print_success "1Password is installed"
        log_info "1Password is installed"
    else
        print_error "1Password is not installed"
        log_error "1Password is not installed"
    fi
    
    # Check Obsidian
    if [[ -d "/Applications/Obsidian.app" ]]; then
        print_success "Obsidian is installed"
        log_info "Obsidian is installed"
    else
        print_error "Obsidian is not installed"
        log_error "Obsidian is not installed"
    fi
}

# Validate Communication Tools
validate_communication() {
    print_in_purple "
   Validating Communication Tools

"
    log_info "Validating Communication Tools"
    
    # Check Slack
    if [[ -d "/Applications/Slack.app" ]]; then
        print_success "Slack is installed"
        log_info "Slack is installed"
    else
        print_error "Slack is not installed"
        log_error "Slack is not installed"
    fi
    
    # Check Discord
    if [[ -d "/Applications/Discord.app" ]]; then
        print_success "Discord is installed"
        log_info "Discord is installed"
    else
        print_error "Discord is not installed"
        log_error "Discord is not installed"
    fi
    
    # Check Zoom
    if [[ -d "/Applications/zoom.us.app" ]]; then
        print_success "Zoom is installed"
        log_info "Zoom is installed"
    else
        print_error "Zoom is not installed"
        log_error "Zoom is not installed"
    fi
    
    # Check Microsoft Teams
    if [[ -d "/Applications/Microsoft Teams.app" ]]; then
        print_success "Microsoft Teams is installed"
        log_info "Microsoft Teams is installed"
    else
        print_error "Microsoft Teams is not installed"
        log_error "Microsoft Teams is not installed"
    fi
}

# Validate Browsers
validate_browsers() {
    print_in_purple "
   Validating Browsers

"
    log_info "Validating Browsers"
    
    # Check Google Chrome
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        print_success "Google Chrome is installed"
        log_info "Google Chrome is installed"
    else
        print_error "Google Chrome is not installed"
        log_error "Google Chrome is not installed"
    fi
    
    # Check Firefox
    if [[ -d "/Applications/Firefox.app" ]]; then
        print_success "Firefox is installed"
        log_info "Firefox is installed"
    else
        print_error "Firefox is not installed"
        log_error "Firefox is not installed"
    fi
    
    # Check Brave
    if [[ -d "/Applications/Brave Browser.app" ]]; then
        print_success "Brave Browser is installed"
        log_info "Brave Browser is installed"
    else
        print_error "Brave Browser is not installed"
        log_error "Brave Browser is not installed"
    fi
}

# Validate Media Tools
validate_media() {
    print_in_purple "
   Validating Media Tools

"
    log_info "Validating Media Tools"
    
    # Check VLC
    if [[ -d "/Applications/VLC.app" ]]; then
        print_success "VLC is installed"
        log_info "VLC is installed"
    else
        print_error "VLC is not installed"
        log_error "VLC is not installed"
    fi
    
    # Check Spotify
    if [[ -d "/Applications/Spotify.app" ]]; then
        print_success "Spotify is installed"
        log_info "Spotify is installed"
    else
        print_error "Spotify is not installed"
        log_error "Spotify is not installed"
    fi
    
    # Check GIMP
    if [[ -d "/Applications/GIMP.app" ]]; then
        print_success "GIMP is installed"
        log_info "GIMP is installed"
    else
        print_error "GIMP is not installed"
        log_error "GIMP is not installed"
    fi
    
    # Check FFmpeg
    check_command "ffmpeg" "FFmpeg"
    
    # Check ImageMagick
    check_command "convert" "ImageMagick"
}

# Validate Utilities
validate_utilities() {
    print_in_purple "
   Validating Utilities

"
    log_info "Validating Utilities"
    
    # Check The Unarchiver
    if [[ -d "/Applications/The Unarchiver.app" ]]; then
        print_success "The Unarchiver is installed"
        log_info "The Unarchiver is installed"
    else
        print_error "The Unarchiver is not installed"
        log_error "The Unarchiver is not installed"
    fi
    
    # Check AppCleaner
    if [[ -d "/Applications/AppCleaner.app" ]]; then
        print_success "AppCleaner is installed"
        log_info "AppCleaner is installed"
    else
        print_error "AppCleaner is not installed"
        log_error "AppCleaner is not installed"
    fi
    
    # Check htop
    check_command "htop" "htop"
    
    # Check wget
    check_command "wget" "wget"
    
    # Check tree
    check_command "tree" "tree"
    
    # Check jq
    check_command "jq" "jq"
    
    # Check ripgrep
    check_command "rg" "ripgrep"
    
    # Check fd
    check_command "fd" "fd"
}

# Main validation function
main() {
    # Validate based on selected groups
    if [[ "${SELECTED_GROUPS[system]}" == "true" ]]; then
        validate_system_setup
    fi
    
    if [[ "${SELECTED_GROUPS[dev_langs]}" == "true" ]]; then
        validate_dev_langs
    fi
    
    if [[ "${SELECTED_GROUPS[ai_ml]}" == "true" ]]; then
        validate_ai_ml
    fi
    
    if [[ "${SELECTED_GROUPS[dev_tools]}" == "true" ]]; then
        validate_dev_tools
    fi
    
    if [[ "${SELECTED_GROUPS[productivity]}" == "true" ]]; then
        validate_productivity
    fi
    
    if [[ "${SELECTED_GROUPS[communication]}" == "true" ]]; then
        validate_communication
    fi
    
    if [[ "${SELECTED_GROUPS[browsers]}" == "true" ]]; then
        validate_browsers
    fi
    
    if [[ "${SELECTED_GROUPS[media]}" == "true" ]]; then
        validate_media
    fi
    
    if [[ "${SELECTED_GROUPS[utilities]}" == "true" ]]; then
        validate_utilities
    fi
    
    print_in_purple "
 >> Validation completed

"
    log_info "Validation completed"
}

# Run the main function
main
