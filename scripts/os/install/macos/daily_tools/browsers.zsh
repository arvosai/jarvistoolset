#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Browsers
"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf "
"

# Modern Browsers
brew install --cask google-chrome
brew install --cask microsoft-edge
brew install --cask firefox
brew install --cask brave-browser

# Optional Browsers
# Uncomment if needed
# brew install --cask opera
# brew install --cask safari-technology-preview
# brew install --cask chromium
# brew install --cask tor-browser

# Note: Flash is deprecated and no longer supported by modern browsers
# brew install --cask flash-npapi
