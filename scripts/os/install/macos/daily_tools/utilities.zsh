#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Installing Utilities

"

# Install The Unarchiver
if brew_install "The Unarchiver" "the-unarchiver" "--cask"; then
    print_success "The Unarchiver installed"
fi

# Install AppCleaner
if brew_install "AppCleaner" "appcleaner" "--cask"; then
    print_success "AppCleaner installed"
fi

# Install htop
if brew_install "htop" "htop"; then
    print_success "htop installed"
fi

# Install wget
if brew_install "wget" "wget"; then
    print_success "wget installed"
fi

# Install tree
if brew_install "tree" "tree"; then
    print_success "tree installed"
fi

# Install jq (JSON processor)
if brew_install "jq" "jq"; then
    print_success "jq installed"
fi

# Install ripgrep
if brew_install "ripgrep" "ripgrep"; then
    print_success "ripgrep installed"
fi

# Install fd (alternative to find)
if brew_install "fd" "fd"; then
    print_success "fd installed"
fi

print_in_purple "
 >> Utilities installation completed

"
