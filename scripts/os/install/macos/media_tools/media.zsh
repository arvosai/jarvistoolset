#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Installing Media Tools

"

# Install VLC
if brew_install "VLC" "vlc" "--cask"; then
    print_success "VLC installed"
fi

# Install Spotify
if brew_install "Spotify" "spotify" "--cask"; then
    print_success "Spotify installed"
fi

# Install GIMP
if brew_install "GIMP" "gimp" "--cask"; then
    print_success "GIMP installed"
fi

# Install ffmpeg
if brew_install "FFmpeg" "ffmpeg"; then
    print_success "FFmpeg installed"
fi

# Install ImageMagick
if brew_install "ImageMagick" "imagemagick"; then
    print_success "ImageMagick installed"
fi

print_in_purple "
 >> Media Tools installation completed

"
