#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures trackpad tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Minimum supported macOS version for this script
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    if ! is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_error "Your macOS version ($current_version) is not supported for Trackpad preferences"
        print_in_yellow "Please upgrade to macOS Sonoma ($MINIMUM_MACOS_VERSION) or later.
"
        return 1
    fi
    
    return 0
}

# Check compatibility before proceeding
if ! check_macos_compatibility; then
    exit 1
fi

# Get macOS major version for version-specific settings
MACOS_MAJOR_VERSION=$(sw_vers -productVersion | cut -d. -f1)

print_in_purple "
   Trackpad

"

# Enable tap to click
execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true" \
    "Enable tap to click for trackpad"

execute "defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true" \
    "Enable tap to click for trackpad (system-wide)"

execute "defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1" \
    "Enable tap to click for the current host"

execute "defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1" \
    "Enable tap to click globally"

# Enable secondary click (right-click)
execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true" \
    "Enable secondary click (right-click) for trackpad"

execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true" \
    "Enable secondary click (right-click) for trackpad (system-wide)"

execute "defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true" \
    "Enable secondary click for the current host"

execute "defaults write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true" \
    "Enable secondary click globally"

# Set tracking speed
execute "defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.0" \
    "Set trackpad tracking speed"

# Enable natural scrolling
execute "defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true" \
    "Enable natural scrolling"

# Enable App Exposé swipe
execute "defaults write com.apple.dock showAppExposeGestureEnabled -bool true" \
    "Enable App Exposé swipe"

# Enable three finger drag
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    # In Sonoma, this setting might be in a different location
    print_in_yellow "Note: In macOS Sonoma, three finger drag must be enabled in System Settings > Accessibility > Pointer Control > Trackpad Options
"
    execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true" \
        "Enable three finger drag (may require manual configuration in System Settings)"
    execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true" \
        "Enable three finger drag for Bluetooth trackpad (may require manual configuration in System Settings)"
else
    execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true" \
        "Enable three finger drag"
    execute "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true" \
        "Enable three finger drag for Bluetooth trackpad"
fi

# Enable Force Click
execute "defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true" \
    "Enable Force Click"

# Configure gesture settings
execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2" \
    "Enable three finger swipe between pages"

execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2" \
    "Enable four finger swipe between full-screen apps"

execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2" \
    "Enable four finger swipe for Mission Control/App Exposé"

execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2" \
    "Enable five finger pinch for Launchpad"

# Configure trackpad corner settings
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    print_in_yellow "Note: In macOS Sonoma, trackpad corner settings may need to be configured in System Settings
"
else
    execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2" \
        "Set bottom right corner to right-click"
fi

# Configure trackpad haptic feedback
execute "defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1" \
    "Set light clicking pressure"

execute "defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1" \
    "Set light second clicking pressure"

# Configure trackpad silent clicking
execute "defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0" \
    "Enable silent clicking"

# Configure trackpad palm rejection
execute "defaults write com.apple.AppleMultitouchTrackpad PalmNoiseReduction -bool true" \
    "Enable palm rejection"

# Configure trackpad zoom settings
execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true" \
    "Enable pinch to zoom"

execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true" \
    "Enable rotate gesture"

# Configure trackpad smart zoom
execute "defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool true" \
    "Enable smart zoom"

# Configure trackpad momentum scrolling
execute "defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool false" \
    "Enable momentum scrolling"

# Restart affected applications
execute "killall Dock" \
    "Restart Dock to apply changes"

execute "killall SystemUIServer" \
    "Restart SystemUIServer to apply changes"
