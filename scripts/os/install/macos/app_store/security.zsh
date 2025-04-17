#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && source "../../utils.zsh" \
    && source "./utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Security Tools

"

# Install security-related tools
brew_install "GPG" "gnupg"
brew_install "Pinentry" "pinentry-mac"
brew_install "IPFS" "ipfs"
brew_install "OpenSSL" "openssl"
brew_install "Keybase" "keybase"
brew_install "Yubikey Manager" "ykman"
brew_install "Tor" "tor"
brew_install "Torsocks" "torsocks"
brew_install "Wireguard" "wireguard-tools"
brew_install "Mkcert" "mkcert"
brew_install "Nmap" "nmap"
brew_install "Hashcat" "hashcat"
brew_install "Vault" "vault"

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

# Create modular configuration file for IPFS
create_ipfs_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/ipfs.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create IPFS configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# IPFS configuration for zsh
# This file contains all IPFS-related configurations
#

# IPFS aliases
alias ipfs-start="ipfs daemon &"
alias ipfs-stop="pkill -f ipfs"
alias ipfs-status="pgrep -l ipfs"
alias ipfs-ls="ipfs ls"
alias ipfs-peers="ipfs swarm peers"
alias ipfs-id="ipfs id"
alias ipfs-cat="ipfs cat"
alias ipfs-add="ipfs add"
alias ipfs-pin="ipfs pin add"
alias ipfs-unpin="ipfs pin rm"

# IPFS functions
ipfs-init() {
    if [ -d "$HOME/.ipfs" ]; then
        echo "IPFS is already initialized"
        return 0
    fi
    
    ipfs init
    echo "IPFS initialized successfully"
}

ipfs-publish() {
    if [ $# -lt 1 ]; then
        echo "Usage: ipfs-publish <file-or-directory>"
        return 1
    fi
    
    local target=$1
    local hash=$(ipfs add -Q -r "$target")
    
    if [ -n "$hash" ]; then
        ipfs name publish "$hash"
        echo "Published $target to IPNS"
        echo "Access via: https://gateway.ipfs.io/ipns/$(ipfs key list -l | grep "self" | awk '{print $2}')"
    else
        echo "Failed to add $target to IPFS"
        return 1
    fi
}

ipfs-get() {
    if [ $# -lt 1 ]; then
        echo "Usage: ipfs-get <hash> [output-dir]"
        return 1
    fi
    
    local hash=$1
    local output_dir=${2:-.}
    
    ipfs get "$hash" -o "$output_dir"
    echo "Downloaded $hash to $output_dir"
}
EOL
    
    print_result $? "Created IPFS configuration file"
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

# Initialize IPFS
initialize_ipfs() {
    print_info "Initializing IPFS..."
    
    # Check if IPFS is already initialized
    if [ -d "$HOME/.ipfs" ]; then
        print_success "IPFS is already initialized"
    else
        # Initialize IPFS
        execute "ipfs init" "Initialize IPFS"
        
        # Configure IPFS
        execute "ipfs config Addresses.API /ip4/127.0.0.1/tcp/5001" "Configure IPFS API address"
        execute "ipfs config Addresses.Gateway /ip4/127.0.0.1/tcp/8080" "Configure IPFS Gateway address"
        
        print_success "IPFS initialized and configured"
    fi
}

# Create modular configurations
create_gpg_config
create_ipfs_config

# Configure tools
configure_gpg
initialize_ipfs

print_in_green "
  Security tools installed and configured!
"
