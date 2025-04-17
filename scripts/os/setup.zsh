#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"
# Source logging script if available
source "${SCRIPT_DIR}/logging.zsh" 2>/dev/null || true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures setup tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Repository configuration
typeset -r GITHUB_REPOSITORY="arvosai/jarvistoolset"
typeset -r JARVIS_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"

# Default configuration
typeset skipQuestions=false

# Default values for user information
HOSTNAME=${1:-$(hostname)}
USERNAME=${2:-$(whoami)}
EMAIL=${3:-"evandro.reis@arvos.ai"}
DIRECTORY=${4:-"$HOME/.jarvistoolset"}

# Export variables for use in other scripts
export HOSTNAME
export USERNAME
export EMAIL
export DIRECTORY

# Log configuration
if type log_info &>/dev/null; then
    log_info "Setup configuration:"
    log_info "  Hostname: $HOSTNAME"
    log_info "  Username: $USERNAME"
    log_info "  Email: $EMAIL"
    log_info "  Directory: $DIRECTORY"
fi

# Script groups for installation
# Ensure we're using zsh associative arrays properly
typeset -A SCRIPT_GROUPS
SCRIPT_GROUPS=(
    "system" "System Setup (xcode, homebrew, oh-my-zsh)"
    "dev_langs" "Development Languages (python, node, ruby, go, java, kotlin, rust, swift, php, cpp)"
    "data_science" "Data Science Environment"
    "dev_tools" "Development Tools (git, docker, vscode, jetbrains, yarn)"
    "web_tools" "Web and Frontend Tools"
    "daily_tools" "Daily Tools and Utilities (browsers, compression, misc, office)"
    "media_tools" "Media and Creative Tools"
    "creative_tools" "Creative and 3D Design Tools (blender, maya, zbrush, unity, unreal)"
    "cloud_tools" "Cloud and DevOps Tools"
    "ai_tools" "AI and Productivity Tools (including Anthropic Libraries and MCP Servers/Clients)"
    "app_store" "App Store and System Tools"
)

# Default: all groups are selected
typeset -A SELECTED_GROUPS
for group in ${(k)SCRIPT_GROUPS}; do
    SELECTED_GROUPS[$group]="true"
done

# ----------------------------------------------------------------------
# | Helper Functions                                                     |
# ----------------------------------------------------------------------

download() {
    local url="$1"
    local output="$2"

    if type log_info &>/dev/null; then
        log_info "Downloading: $url to $output"
    fi

    if (( $+commands[curl] )); then
        if type execute_with_log &>/dev/null; then
            execute_with_log "curl -LsSo \"$output\" \"$url\"" "Downloading $url"
        else
            curl -LsSo "$output" "$url" &> /dev/null
            #     │││└─ write output to file
            #     ││└─ show error messages
            #     │└─ don't show the progress meter
            #     └─ follow redirects
        fi
        return $?
    elif (( $+commands[wget] )); then
        if type execute_with_log &>/dev/null; then
            execute_with_log "wget -qO \"$output\" \"$url\"" "Downloading $url"
        else
            wget -qO "$output" "$url" &> /dev/null
            #     │└─ write output to file
            #     └─ don't show output
        fi
        return $?
    fi
    
    if type log_error &>/dev/null; then
        log_error "Neither curl nor wget is available for downloading"
    fi
    return 1
}

download_utils() {
    local tmpFile=""

    tmpFile="$(mktemp /tmp/XXXXX)"
    download "$JARVIS_UTILS_URL" "$tmpFile" \
        && source "$tmpFile" \
        && rm -rf "$tmpFile" \
        && return 0

    return 1
}

verify_os() {
    local os_name=""
    os_name="$(get_os)"

    if type log_info &>/dev/null; then
        log_info "Verifying operating system: $os_name"
    fi

    if [[ "$os_name" = "macos" ]]; then
        if type log_success &>/dev/null; then
            log_success "Operating system verified: macOS"
        fi
        return 0
    else
        printf "Sorry, this script is intended only for macOS.
"
        if type log_error &>/dev/null; then
            log_error "Operating system verification failed: $os_name is not supported"
        fi
        return 1
    fi
}

install_homebrew() {
    if ! (( $+commands[brew] )); then
        print_in_purple "
 >> Installing Homebrew

"
        
        if type log_info &>/dev/null; then
            log_info "Installing Homebrew"
        fi
        
        # Install Homebrew using the official script
        if type execute_with_log &>/dev/null; then
            execute_with_log "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Installing Homebrew"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &> /dev/null
        fi
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ "$(uname -m)" = "arm64" ]]; then
            if ! grep -q 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile"; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
                eval "$(/opt/homebrew/bin/brew shellenv)"
                
                if type log_info &>/dev/null; then
                    log_info "Added Homebrew to PATH for Apple Silicon Mac"
                fi
            fi
        fi
        
        print_result $? "Homebrew"
        
        if type log_info &>/dev/null; then
            if [ $? -eq 0 ]; then
                log_success "Homebrew installed successfully"
            else
                log_error "Failed to install Homebrew"
            fi
        fi
    else
        if type log_info &>/dev/null; then
            log_info "Homebrew is already installed"
        fi
    fi
    
    return 0
}

install_figlet() {
    if ! (( $+commands[figlet] )); then
        if type log_info &>/dev/null; then
            log_info "Installing figlet"
        fi
        
        # Install Homebrew if not already installed (silently)
        install_homebrew > /dev/null 2>&1
        
        # Install figlet using Homebrew (silently)
        if type execute_with_log &>/dev/null; then
            execute_with_log "brew install figlet" "Installing figlet"
        else
            brew install figlet > /dev/null 2>&1
        fi
        
        if type log_info &>/dev/null; then
            if (( $+commands[figlet] )); then
                log_success "figlet installed successfully"
            else
                log_error "Failed to install figlet"
            fi
        fi
    else
        if type log_info &>/dev/null; then
            log_info "figlet is already installed"
        fi
    fi
    
    return 0
}

install_git() {
    if ! (( $+commands[git] )); then
        print_in_purple "
 >> Installing Git

"
        
        if type log_info &>/dev/null; then
            log_info "Installing Git"
        fi
        
        # Install Homebrew if not already installed
        install_homebrew
        
        # Install Git using Homebrew
        if type execute_with_log &>/dev/null; then
            execute_with_log "brew install git" "Installing Git"
        else
            brew install git &> /dev/null
        fi
        
        print_result $? "Git"
        
        # Make Git available in the current shell session
        if [[ "$(uname -m)" = "arm64" ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
        else
            export PATH="/usr/local/bin:$PATH"
        fi
        
        # Verify Git is now available
        if (( $+commands[git] )); then
            print_success "Git is now available"
            if type log_success &>/dev/null; then
                log_success "Git installed and available in PATH"
            fi
        else
            print_error "Git installation failed or Git is not in PATH"
            if type log_error &>/dev/null; then
                log_error "Git installation failed or Git is not in PATH"
            fi
            exit 1
        fi
    else
        if type log_info &>/dev/null; then
            log_info "Git is already installed"
        fi
    fi
    
    return 0
}

display_banner() {
    if (( $+commands[figlet] )); then
        print_in_yellow "$(figlet -f ogre -c 'Jarvis Toolset')
"
        print_in_yellow "Welcome to ARVOS.AI Jarvis Toolset 25H1 Edition, the complete Mac OS tools and apps installer for AI and Vibe Coders!
"
        print_in_yellow "Copyright (c) 2025 ARVOS.AI. All rights reserved.
"
        
        if type log_info &>/dev/null; then
            log_info "Displayed Jarvis Toolset banner with figlet"
        fi
    else
        print_in_yellow "
 >> Welcome to ARVOS.AI Jarvis Toolset 25H1 Edition, the complete Mac OS tools and apps installer for AI and Vibe Coders!
"
        print_in_yellow "Copyright (c) 2025 ARVOS.AI. All rights reserved.
"
        
        if type log_info &>/dev/null; then
            log_info "Displayed Jarvis Toolset banner (figlet not available)"
        fi
    fi
}

# Interactive menu to select script groups
select_script_groups() {
    local answer
    
    print_in_purple "
 >> Installation Options

"
    print_in_yellow "Would you like to install the complete toolset or select specific groups?

"
    print_in_yellow "1) Install complete toolset (all groups)
"
    print_in_yellow "2) Select specific groups to install

"
    
    answer=""
    vared -p $'Enter your choice (1/2): ' answer
    
    if [[ "$answer" == "2" ]]; then
        # Reset all groups to false
        for group in ${(k)SCRIPT_GROUPS}; do
            SELECTED_GROUPS[$group]="false"
        done
        
        print_in_purple "
 >> Available groups to install

"

        for group in ${(k)SCRIPT_GROUPS}; do
            local group_answer=""
            
            vared -p $'Install '"${SCRIPT_GROUPS[$group]}"$'? (y/n): ' group_answer
            
            if [[ "$group_answer" =~ ^[Yy]$ ]]; then
                SELECTED_GROUPS[$group]="true"
            else
                SELECTED_GROUPS[$group]="false"
            fi
        done
        
        # Summary of selected groups
        print_in_purple "
 >> Installation Summary

"
        for group in ${(k)SCRIPT_GROUPS}; do
            if [[ "${SELECTED_GROUPS[$group]}" == "true" ]]; then
                print_in_green "Will install: ${SCRIPT_GROUPS[$group]}
"
            else
                print_in_red   "Will skip...: ${SCRIPT_GROUPS[$group]}
"
            fi
        done
        
        # Confirmation
        local confirm_answer=""
        vared -p $'

 >> Proceed with installation? (y/n): ' confirm_answer
        
        if [[ ! "$confirm_answer" =~ ^[Yy]$ ]]; then
            print_in_red "

** Installation cancelled by user!!

"
            exit 0
        fi
    else
        print_in_green "

Installing complete toolset (all groups).

"
    fi
}

# Function to update configuration
update_configuration() {
    local update_config=""
    
    vared -p $'Would you like to update this configuration? (y/n): ' update_config
    
    if [[ "$update_config" =~ ^[Yy]$ ]]; then
        print_in_yellow "
Enter new values (or press Enter to keep current value):
"
        
        # Update hostname
        local new_hostname=""
        vared -p $'Hostname ['"$HOSTNAME"$']: ' new_hostname
        
        if [[ -n "$new_hostname" ]]; then
            HOSTNAME="$new_hostname"
        fi
        
        # Update username
        local new_username=""
        vared -p $'Username ['"$USERNAME"$']: ' new_username
        
        if [[ -n "$new_username" ]]; then
            USERNAME="$new_username"
        fi
        
        # Update email
        local new_email=""
        vared -p $'Email ['"$EMAIL"$']: ' new_email
        
        if [[ -n "$new_email" ]]; then
            EMAIL="$new_email"
        fi
        
        # Update directory
        local new_directory=""
        vared -p $'Directory ['"$DIRECTORY"$']: ' new_directory
        
        if [[ -n "$new_directory" ]]; then
            DIRECTORY="$new_directory"
        fi
        
        # Display updated configuration
        print_in_green "
 >> Updated configuration:
"
        print_in_green "---------------------------------------------------------------
"
        print_in_green "Hostname: $HOSTNAME
"
        print_in_green "Username : $USERNAME
"
        print_in_green "Email    : $EMAIL
"
        print_in_green "Directory: $DIRECTORY
"
        print_in_green "---------------------------------------------------------------
"
    else
        print_in_yellow "Continuing with current configuration.
"
    fi
}

# ----------------------------------------------------------------------
# | Main                                                                |
# ----------------------------------------------------------------------

main() {
    # Ensure that the following actions
    # are made relative to this file's path.
    
    clear
    
    cd "$(dirname "${BASH_SOURCE[0]}")" \
        || exit 1

    # Load utils
    source "./utils.zsh"
    # Install figlet for banner display
    install_figlet
    
    # Display welcome banner
    display_banner
    
    # Ask for sudo password upfront and keep sudo credentials alive
    print_in_purple "
 >> Requesting administrator privileges...

"
    ask_for_sudo

    # Create a sudo timestamp directory with appropriate permissions
    setup_sudo_timestamp_dir() {
        local sudo_timestamp_dir="/var/run/sudo/${USER}"
        
        # Create the timestamp directory if it doesn't exist
        if [ ! -d "$sudo_timestamp_dir" ]; then
            sudo mkdir -p "$sudo_timestamp_dir" 2>/dev/null
            sudo chmod 700 "$sudo_timestamp_dir" 2>/dev/null
        fi
        
        # Set the sudo timeout to 2 hours (7200 seconds)
        sudo sh -c "echo 'Defaults:${USER} timestamp_timeout=7200' > /etc/sudoers.d/jarvis_timeout"
        sudo chmod 440 /etc/sudoers.d/jarvis_timeout
        
        # Export the SUDO_REQUESTED variable to child processes
        export SUDO_REQUESTED=true
    }

    # Set up the sudo timestamp directory
    setup_sudo_timestamp_dir

    # Display information about what's happening
    print_in_green "
 >> Starting Jarvis Toolset with the following configuration:
"
    print_in_green "---------------------------------------------------------------
"
    print_in_green "Hostname : $HOSTNAME
"
    print_in_green "Username : $USERNAME
"
    print_in_green "Email    : $EMAIL
"
    print_in_green "Directory: $DIRECTORY
"
    print_in_green "---------------------------------------------------------------
"
    
    # Ask if user wants to update configuration
    update_configuration
    
    # Ensure the script is run on macOS
    verify_os || exit 1

    # Install Git if not already installed
    install_git

    # Initialize SELECTED_GROUPS as a global associative array
    typeset -gA SELECTED_GROUPS
    # Default: all groups are selected
    for group in ${(k)SCRIPT_GROUPS}; do
        SELECTED_GROUPS[$group]="true"
    done
    
    # Interactive menu to select script groups
    select_script_groups
    
    # Export the SELECTED_GROUPS associative array
    # This needs to be done before sourcing any scripts that use it
    export SELECTED_GROUPS

    # Create directories
    source "${SCRIPT_DIR}/create_directories.zsh"
    
    # Create local config files
    source "${SCRIPT_DIR}/create_local_config_files.zsh"

    # Install everything
    source "${SCRIPT_DIR}/install/macos/main.zsh" \
        "$HOSTNAME" \
        "$USERNAME" \
        "$EMAIL" \
        "$DIRECTORY"

    print_in_purple "
 >> Setup completed! Please restart your terminal.

"
}

main "$@"
