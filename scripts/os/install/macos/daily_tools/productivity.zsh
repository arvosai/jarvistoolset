#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Installing Productivity Tools

"

# Install Alfred (Spotlight replacement)
if brew_install "Alfred" "alfred" "--cask"; then
    print_success "Alfred installed"
fi

# Install Rectangle (window management)
if brew_install "Rectangle" "rectangle" "--cask"; then
    print_success "Rectangle installed"
fi

# Install Notion
if brew_install "Notion" "notion" "--cask"; then
    print_success "Notion installed"
fi

# Install 1Password
if brew_install "1Password" "1password" "--cask"; then
    print_success "1Password installed"
fi

# Install Obsidian
if brew_install "Obsidian" "obsidian" "--cask"; then
    print_success "Obsidian installed"
fi

print_in_purple "
 >> Productivity Tools installation completed

"
