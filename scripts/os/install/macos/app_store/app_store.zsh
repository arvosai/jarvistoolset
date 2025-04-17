#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Mac App Store

"

# Check if mas-cli is installed (required for Mac App Store automation)
if ! cmd_exists "mas"; then
    print_error "mas-cli is required but not installed"
    print_info "Installing mas-cli..."
    brew_install "mas" "mas"
fi

# Check if user is signed in to the Mac App Store
if ! mas account > /dev/null; then
    print_warning "Please sign in to the Mac App Store first"
    open -a "App Store"
    return 1
fi

# Development
execute "mas install 497799835" \
    "Install Xcode"

execute "mas install 1091189122" \
    "Install Bear"

# Productivity
execute "mas install 904280696" \
    "Install Things 3"

execute "mas install 1278508951" \
    "Install Trello"

execute "mas install 441258766" \
    "Install Magnet"

execute "mas install 1176895641" \
    "Install Spark"

# Graphics & Design
execute "mas install 409183694" \
    "Install Keynote"

execute "mas install 409201541" \
    "Install Pages"

execute "mas install 409203825" \
    "Install Numbers"

execute "mas install 1289583905" \
    "Install Pixelmator Pro"

# Utilities
execute "mas install 425424353" \
    "Install The Unarchiver"

execute "mas install 937984704" \
    "Install Amphetamine"

execute "mas install 1451685025" \
    "Install WireGuard"

execute "mas install 1147396723" \
    "Install WhatsApp"

# Security & Privacy
execute "mas install 1352778147" \
    "Install Bitwarden"

execute "mas install 1480933944" \
    "Install Vimari"

# Writing & Notes
execute "mas install 1091189122" \
    "Install Bear"

execute "mas install 775737590" \
    "Install iA Writer"

# System Cleanup
execute "mas upgrade" \
    "Upgrade all Mac App Store apps"

print_in_purple "
   Finished Mac App Store installations

"
