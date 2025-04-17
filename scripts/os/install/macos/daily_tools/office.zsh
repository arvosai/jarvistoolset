#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh" \
    source "./utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Office 365
"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf "
"

brew_install "Office 365" "microsoft-office" "caskroom/cask" "cask"
brew_install "Microsoft Teams" "microsoft-teams" "caskroom/versions" "cask"
brew_install "Xmind:ZEN" "xmind-zen" "caskroom/versions" "cask"
