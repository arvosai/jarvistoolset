#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Applications\n\n"

# Productivity
brew_install "1Password" "1password" "--cask"
brew_install "Alfred" "alfred" "--cask"
brew_install "Notion" "notion" "--cask"
brew_install "Rectangle" "rectangle" "--cask"
brew_install "Obsidian" "obsidian" "--cask"

# Communication
brew_install "Slack" "slack" "--cask"
brew_install "Discord" "discord" "--cask"
brew_install "Zoom" "zoom" "--cask"
brew_install "WhatsApp" "whatsapp" "--cask"
brew_install "Telegram" "telegram" "--cask"

# Browsers
brew_install "Google Chrome" "google-chrome" "--cask"
brew_install "Firefox" "firefox" "--cask"
brew_install "Brave Browser" "brave-browser" "--cask"

# Media
brew_install "Spotify" "spotify" "--cask"
brew_install "VLC" "vlc" "--cask"
brew_install "HandBrake" "handbrake" "--cask"

# Cloud Storage
brew_install "Dropbox" "dropbox" "--cask"
brew_install "Google Drive" "google-drive" "--cask"

# Design & Creative
brew_install "Figma" "figma" "--cask"
brew_install "Inkscape" "inkscape" "--cask"
brew_install "GIMP" "gimp" "--cask"

# Writing & Notes
brew_install "Visual Studio Code" "visual-studio-code" "--cask"
brew_install "Sublime Text" "sublime-text" "--cask"

# System Utilities
brew_install "AppCleaner" "appcleaner" "--cask"
brew_install "The Unarchiver" "the-unarchiver" "--cask"
brew_install "Caffeine" "caffeine" "--cask"
brew_install "Stats" "stats" "--cask"
brew_install "Karabiner-Elements" "karabiner-elements" "--cask"

# Security
brew_install "Little Snitch" "little-snitch" "--cask"
brew_install "Malwarebytes" "malwarebytes" "--cask"

# Quick Look plugins
brew_install "QLColorCode" "qlcolorcode" "--cask"
brew_install "QuickLook JSON" "quicklook-json" "--cask"
brew_install "QuickLook CSV" "quicklook-csv" "--cask"
brew_install "QLStephen" "qlstephen" "--cask"
brew_install "QLMarkdown" "qlmarkdown" "--cask"

# Command Line Tools
brew_install "mas" "mas"  # Mac App Store command line interface
brew_install "tree" "tree"
brew_install "wget" "wget"
brew_install "htop" "htop"
brew_install "tldr" "tldr"
brew_install "bat" "bat"
brew_install "exa" "exa"
brew_install "fd" "fd"
brew_install "ripgrep" "ripgrep"

# Install Mac App Store apps
# Note: You need to be signed in to the Mac App Store for this to work

# Clean up
execute "brew cleanup" \
    "Clean up Homebrew cache"
