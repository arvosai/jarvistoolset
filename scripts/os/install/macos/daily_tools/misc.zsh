#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh" \
    source "./utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Miscelânea

"

brew_install "Android File Transfer" "android-file-transfer" "caskroom/cask" "cask"
brew_install "Spectacle" "spectacle" "caskroom/cask" "cask"
brew_install "The Unarchiver" "the-unarchiver" "caskroom/cask" "cask"
brew_install "Transmission" "transmission" "caskroom/cask" "cask"
