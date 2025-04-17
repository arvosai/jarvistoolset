#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh" \
    source "./utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Image Tools

"

brew_install "GIMP" "gimp" "" "cask"
brew_install "ImageAlpha" "imagealpha" "" "cask"
brew_install "ImageMagick" "imagemagick"
brew_install "ImageOptim" "imageoptim" "" "cask"
brew_install "LICEcap" "licecap" "" "cask"
brew_install "Webp" "webp"
