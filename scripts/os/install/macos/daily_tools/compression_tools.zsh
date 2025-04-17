#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Compression Tools

"

# Standard Compression Tools
brew_install "Brotli" "brotli"
brew_install "Zopfli" "zopfli"

# Additional Compression Tools
brew_install "7-Zip" "p7zip"
brew_install "Unrar" "unrar"
brew_install "XZ Utils" "xz"
brew_install "Zstandard" "zstd"

# Archive Management
brew_install "The Unarchiver" "the-unarchiver" "--cask"

# Optional Advanced Tools
# Uncomment if needed
# brew_install "LZFSE" "lzfse"
# brew_install "LZ4" "lz4"
# brew_install "ZPAQ" "zpaq"
