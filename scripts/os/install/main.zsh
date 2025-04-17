#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures main tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Create a banner for this installation script
create_install_banner "$0"


# Function to create a framed header with script information
create_header() {
    local script_name="${1:-"Jarvis Installation Script"}"
    local version="${2:-"1.0.0"}"
    local description="${3:-"This script will install and configure your development environment"}"
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

# Default values
HOSTNAME=${1:-$(hostname)}
USERNAME=${2:-$(whoami)}
EMAIL=${3:-"$DIRECTORY"}
DIRECTORY=${4:-"$HOME"}

# Create header
create_header "Jarvis Installation Script" "1.0.0" "Installing and configuring your development environment"

# Log the script execution
if type log_info &>/dev/null; then
    log_info "Running install/main.zsh with SELECTED_GROUPS: ${(k)SELECTED_GROUPS}"
fi

# Get OS type and run appropriate setup script
OS_TYPE=$(get_os)
if [[ -f "${SCRIPT_DIR}/${OS_TYPE}/main.zsh" ]]; then
    # Make sure SELECTED_GROUPS is exported
    export SELECTED_GROUPS
    source "${SCRIPT_DIR}/${OS_TYPE}/main.zsh"
else
    print_error "Unsupported operating system: ${OS_TYPE}"
    exit 1
fi

print_in_purple "
 >> Installation completed!

"
