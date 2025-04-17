#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Extra Tools

"

# Productivity Tools
brew_install "Alfred" "alfred" "--cask"
brew_install "Raycast" "raycast" "--cask"
brew_install "Dash" "dash" "--cask"
brew_install "Rectangle" "rectangle" "--cask"
brew_install "Caffeine" "caffeine" "--cask"
brew_install "Bartender" "bartender" "--cask"

# System Utilities
brew_install "CleanMyMac X" "cleanmymac" "--cask"
brew_install "Disk Inventory X" "disk-inventory-x" "--cask"
brew_install "AppCleaner" "appcleaner" "--cask"
brew_install "The Unarchiver" "the-unarchiver" "--cask"
brew_install "Amphetamine" "amphetamine" "--cask"

# Security Tools
brew_install "1Password" "1password" "--cask"
brew_install "GPG Suite" "gpg-suite" "--cask"
brew_install "Little Snitch" "little-snitch" "--cask"
brew_install "Micro Snitch" "micro-snitch" "--cask"

# Creative Tools
brew_install "Adobe Creative Cloud" "adobe-creative-cloud" "--cask"
brew_install "Figma" "figma" "--cask"
brew_install "Sketch" "sketch" "--cask"

# Screen Recording and Capture
brew_install "Licecap" "licecap" "--cask"
brew_install "Kap" "kap" "--cask"
brew_install "OBS" "obs" "--cask"

# File Management and Sync
brew_install "GoodSync" "goodsync" "--cask"
brew_install "Dropbox" "dropbox" "--cask"
brew_install "Google Drive" "google-drive" "--cask"

# Communication
brew_install "Slack" "slack" "--cask"
brew_install "Discord" "discord" "--cask"
brew_install "Zoom" "zoom" "--cask"

# Media Tools
brew_install "VLC" "vlc" "--cask"
brew_install "IINA" "iina" "--cask"
brew_install "Spotify" "spotify" "--cask"

# Writing and Notes
brew_install "Notion" "notion" "--cask"
brew_install "Obsidian" "obsidian" "--cask"
brew_install "Typora" "typora" "--cask"

# Optional Tools
# Uncomment if needed
# brew_install "Evernote" "evernote" "--cask"
# brew_install "Microsoft Office" "microsoft-office" "--cask"
# brew_install "TeamViewer" "teamviewer" "--cask"
# brew_install "NordVPN" "nordvpn" "--cask"
# brew_install "Parallels" "parallels" "--cask"
# brew_install "VMware Fusion" "vmware-fusion" "--cask"
# brew_install "CrossOver" "crossover" "--cask"
# brew_install "Grammarly Desktop" "grammarly-desktop" "--cask"
