#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Installing Communication Tools

"

# Install Slack
if brew_install "Slack" "slack" "--cask"; then
    print_success "Slack installed"
fi

# Install Discord
if brew_install "Discord" "discord" "--cask"; then
    print_success "Discord installed"
fi

# Install Zoom
if brew_install "Zoom" "zoom" "--cask"; then
    print_success "Zoom installed"
fi

# Install Microsoft Teams
if brew_install "Microsoft Teams" "microsoft-teams" "--cask"; then
    print_success "Microsoft Teams installed"
fi

print_in_purple "
 >> Communication Tools installation completed

"
