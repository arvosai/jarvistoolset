#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# Enable nullglob to handle the case where there are no matches for a glob pattern
setopt nullglob

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Function to create a framed header with script information
create_header() {
    local script_name="${1:-"macOS Setup Script"}"
    local version="${2:-"1.0.0"}"
    local description="${3:-"This script will install and configure your macOS development environment"}"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local width=80
    local line=$(printf '%*s' "$width" | tr ' ' '=')
    
    echo "
$line"
    echo "||  ${script_name} v${version}"
    echo "||  ${timestamp}"
    echo "||"
    echo "||  ${description}"
    echo "$line
"
}

# Create header
create_header "macOS Setup Script" "1.0.0" "Installing and configuring your macOS development environment"

print_in_purple "
 >> Starting macOS setup

"

# Log the available script groups
if type log_info &>/dev/null; then
    log_info "Available script groups in macos/main.zsh: ${(k)SELECTED_GROUPS}"
    for group in ${(k)SELECTED_GROUPS}; do
        log_info "Group $group: ${SELECTED_GROUPS[$group]}"
    done
fi

# Create zsh_configs directory for modular configurations
mkdir -p "$HOME/.jarvistoolset/zsh_configs"
print_success "Created modular configuration directory at $HOME/.jarvistoolset/zsh_configs
"

SCRIPT_DIR_INSTALL_MACOS="$SCRIPT_DIR/install/macos"

# System setup scripts
if [[ "${SELECTED_GROUPS[system]}" == "true" ]]; then
    log_info "Installing System Setup"
    print_in_purple "
 >> Installing System Setup

"
    
    # Source all scripts in the system directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/system"/*.zsh; do
        if [ -f "$script" ]; then
            log_info "Sourcing script: $script"
            source "$script"
        fi
    done
    log_success "System Setup installation complete"
else
    log_info "Skipping System Setup"
    print_in_red "
 >> Skipping System Setup

"
fi

# Development languages
if [[ "${SELECTED_GROUPS[dev_langs]}" == "true" ]]; then
    print_in_purple "
 >> Installing Development Languages

"
    
    # Source all scripts in the dev_langs directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/dev_langs"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Development Languages

"
fi

# Data Science Environment
if [[ "${SELECTED_GROUPS[data_science]}" == "true" ]]; then
    print_in_purple "
 >> Installing Data Science Environment

"
    
    # Source all scripts in the data_science directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/data_science"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Data Science Environment

"
fi

# AI and ML Tools
if [[ "${SELECTED_GROUPS[ai_tools]}" == "true" ]]; then
    print_in_purple "
 >> Installing AI and Productivity Tools

"
    
    # Source all scripts in the ai_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/ai_tools"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping AI and Productivity Tools

"
fi

# Development Tools
if [[ "${SELECTED_GROUPS[dev_tools]}" == "true" ]]; then
    print_in_purple "
 >> Installing Development Tools

"
    
    # Source all scripts in the dev_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/dev_tools"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Development Tools

"
fi

# Web and Frontend Tools
if [[ "${SELECTED_GROUPS[web_tools]}" == "true" ]]; then
    print_in_purple "
 >> Installing Web and Frontend Tools

"
    
    # Source all scripts in the web_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/web_tools"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Web and Frontend Tools

"
fi

# Daily Tools and Utilities
if [[ "${SELECTED_GROUPS[daily_tools]}" == "true" ]]; then
    print_in_purple "
 >> Installing Daily Tools and Utilities

"
    
    # Source all scripts in the daily_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/daily_tools"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Daily Tools and Utilities

"
fi

# Media and Creative Tools
if [[ "${SELECTED_GROUPS[media_tools]}" == "true" ]]; then
    print_in_purple "
 >> Installing Media and Creative Tools

"
    
    # Source all scripts in the media_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/media_tools"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Media and Creative Tools

"
fi

# Creative and 3D Design Tools
if [[ "${SELECTED_GROUPS[creative_tools]}" == "true" ]]; then
    log_info "Installing Creative and 3D Design Tools"
    print_in_purple "
 >> Installing Creative and 3D Design Tools

"
    
    # Source all scripts in the creative_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/creative_tools"/*.zsh; do
        if [ -f "$script" ]; then
            log_info "Sourcing script: $script"
            source "$script"
        fi
    done
    log_success "Creative and 3D Design Tools installation complete"
else
    log_info "Skipping Creative and 3D Design Tools installation"
    print_in_red "
 >> Skipping Creative and 3D Design Tools

"
fi

# Cloud and DevOps Tools
if [[ "${SELECTED_GROUPS[cloud_tools]}" == "true" ]]; then
    print_in_purple "
 >> Installing Cloud and DevOps Tools

"
    
    # Source all scripts in the cloud_tools directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/cloud_tools"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping Cloud and DevOps Tools

"
fi

# App Store and System Tools
if [[ "${SELECTED_GROUPS[app_store]}" == "true" ]]; then
    print_in_purple "
 >> Installing App Store and System Tools

"
    
    # Source all scripts in the app_store directory
    for script in "${SCRIPT_DIR_INSTALL_MACOS}/app_store"/*.zsh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
else
    print_in_red "
 >> Skipping App Store and System Tools

"
fi

# Run cleanup and validation
print_in_purple "
 >> Running cleanup and validation

"
source "${SCRIPT_DIR_INSTALL_MACOS}/utils/cleanup.zsh"
source "${SCRIPT_DIR_INSTALL_MACOS}/utils/validate_installations.zsh"

print_in_green "
 >> macOS setup completed!

"
