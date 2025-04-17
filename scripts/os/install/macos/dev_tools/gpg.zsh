#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   GPG Tools

"

# Core GPG Tools
if brew list | grep -q "gnupg"; then
    print_success "GPG (already installed)"
else
    brew install gnupg &> /dev/null
    print_result $? "GPG"
fi

if brew list | grep -q "pinentry-mac"; then
    print_success "Pinentry Mac (already installed)"
else
    brew install pinentry-mac &> /dev/null
    print_result $? "Pinentry Mac"
fi

if brew list --cask | grep -q "gpg-suite"; then
    print_success "GPG Suite (already installed)"
else
    brew install --cask gpg-suite &> /dev/null
    print_result $? "GPG Suite"
fi

# GPG Utilities
if brew list --cask | grep -q "keybase"; then
    print_success "Keybase (already installed)"
else
    brew install --cask keybase &> /dev/null
    print_result $? "Keybase"
fi

# Note: gpgtools is a tap, not a formula
print_warning "GPG Tools is part of GPG Suite which is already installed"

# GPG Agent is included with gnupg
if command -v gpg-agent &> /dev/null; then
    print_success "GPG Agent (already installed)"
else
    print_warning "GPG Agent is included with gnupg and should already be available"
fi

# Smart Card Support
if command -v pcsc_scan &> /dev/null || brew list | grep -q "pcsclite"; then
    print_success "PCSC-Lite (already installed)"
else
    brew install pcsclite &> /dev/null
    if [ $? -eq 0 ]; then
        print_success "PCSC-Lite"
    else
        print_warning "PCSC-Lite installation failed (optional - skipped)"
    fi
fi

if command -v ykman &> /dev/null || brew list | grep -q "yubikey-manager"; then
    print_success "YubiKey Manager (already installed)"
else
    brew install yubikey-manager &> /dev/null
    if [ $? -eq 0 ]; then
        print_success "YubiKey Manager"
    else
        print_warning "YubiKey Manager installation failed (optional - skipped)"
    fi
fi

if brew list --cask 2>/dev/null | grep -q "yubikey-personalization-gui"; then
    print_success "YubiKey Personalization GUI (already installed)"
else
    brew install --cask yubikey-personalization-gui &> /dev/null
    if [ $? -eq 0 ]; then
        print_success "YubiKey Personalization GUI"
    else
        print_warning "YubiKey Personalization GUI installation failed (optional - skipped)"
    fi
fi

# Configure GPG Agent
print_in_purple "
   GPG Configuration

"

# Create modular configuration file for GPG
create_gpg_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/gpg.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create GPG configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# GPG configuration for zsh
# This file contains all GPG-related configurations
#

# Set GPG TTY
export GPG_TTY=$(tty)

# GPG aliases
alias gpg-list="gpg --list-keys"
alias gpg-list-secret="gpg --list-secret-keys"
alias gpg-refresh="gpg --refresh-keys"

# GPG functions
gpg-export() {
    if [ $# -ne 1 ]; then
        echo "Usage: gpg-export <key-id>"
        return 1
    fi
    
    local key_id=$1
    gpg --armor --export "$key_id"
}

gpg-export-secret() {
    if [ $# -ne 1 ]; then
        echo "Usage: gpg-export-secret <key-id>"
        return 1
    fi
    
    local key_id=$1
    gpg --armor --export-secret-key "$key_id"
}

gpg-import() {
    if [ $# -ne 1 ]; then
        echo "Usage: gpg-import <key-file>"
        return 1
    fi
    
    local key_file=$1
    gpg --import "$key_file"
}
EOL
    
    print_result $? "Created GPG configuration file"
}

# Configure GPG
configure_gpg() {
    print_info "Configuring GPG..."
    
    # Create GPG configuration directory
    mkdir -p "$HOME/.gnupg"
    
    # Set proper permissions
    chmod 700 "$HOME/.gnupg"
    
    # Create GPG agent configuration
    cat > "$HOME/.gnupg/gpg-agent.conf" << EOL
default-cache-ttl 3600
max-cache-ttl 86400
pinentry-program /usr/local/bin/pinentry-mac
EOL
    
    # Create GPG configuration
    cat > "$HOME/.gnupg/gpg.conf" << EOL
use-agent
personal-cipher-preferences AES256 AES192 AES
personal-digest-preferences SHA512 SHA384 SHA256
personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
require-cross-certification
no-symkey-cache
throw-keyids
EOL
    
    print_result $? "GPG configuration"
}

# Create modular configuration
create_gpg_config

# Configure GPG
configure_gpg

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/gpg.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the GPG config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load GPG configuration
source "$HOME/.jarvistoolset/zsh_configs/gpg.zsh"
EOL
    print_result $? "Added GPG configuration to .zshrc"
fi

# Restart GPG Agent
gpgconf --kill gpg-agent &> /dev/null
print_result $? "Restart GPG agent"

# Configure Git to use GPG signing
git config --global commit.gpgsign true &> /dev/null
print_result $? "Enable GPG signing for Git commits"

git config --global gpg.program $(which gpg) &> /dev/null
print_result $? "Set GPG program for Git"

print_in_green "
  GPG tools setup complete!
"
