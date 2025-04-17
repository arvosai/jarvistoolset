#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures dock tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Minimum supported macOS version for this script
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    if ! is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_error "Your macOS version ($current_version) is not supported for Dock preferences"
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

print_in_purple "
   Dock

"

# Dock Appearance
execute "defaults write com.apple.dock autohide -bool true" \
    "Automatically hide/show the Dock"

execute "defaults write com.apple.dock autohide-delay -float 0" \
    "Remove the auto-hiding Dock delay"

execute "defaults write com.apple.dock autohide-time-modifier -float 0.5" \
    "Set the animation time when hiding/showing the Dock"

execute "defaults write com.apple.dock largesize -int 128" \
    "Set the large size of Dock items"

execute "defaults write com.apple.dock magnification -bool true" \
    "Enable magnification"

execute "defaults write com.apple.dock tilesize -int 36" \
    "Set the icon size of Dock items"

execute "defaults write com.apple.dock size-immutable -bool true" \
    "Lock the Dock size"

execute "defaults write com.apple.dock orientation -string 'bottom'" \
    "Position the Dock on the bottom"

execute "defaults write com.apple.dock show-recents -bool false" \
    "Don't show recent applications in Dock"

# Dock Behavior
execute "defaults write com.apple.dock mouse-over-hilite-stack -boolean yes" \
    "Enable highlight hover effect for stacks"

execute "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true" \
    "Enable spring loading for all Dock items"

execute "defaults write com.apple.dock expose-group-by-app -bool false" \
    "Don't group windows by application in Mission Control"

execute "defaults write com.apple.dock mineffect -string 'scale'" \
    "Change minimize/maximize window effect"

execute "defaults write com.apple.dock minimize-to-application -bool true" \
    "Minimize windows into their application's icon"

execute "defaults write com.apple.dock mru-spaces -bool false" \
    "Don't automatically rearrange Spaces based on most recent use"

execute "defaults write com.apple.dock show-process-indicators -bool true" \
    "Show indicator lights for open applications"

execute "defaults write com.apple.dock showhidden -bool true" \
    "Make hidden applications translucent in the Dock"

execute "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true" \
    "Enable spring loading for all Dock items"

# Modern macOS uses persistent-apps differently - clear with caution
if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 14 ]]; then
    print_in_yellow "Note: Not removing persistent apps from Dock on macOS Sonoma or later
"
else
    execute "defaults write com.apple.dock persistent-apps -array" \
        "Remove all persistent apps from Dock"
fi

# This setting might not work as expected in newer macOS versions
if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 14 ]]; then
    print_in_yellow "Note: 'Show only active applications' may not work as expected in macOS Sonoma or later
"
else
    execute "defaults write com.apple.dock static-only -bool true" \
        "Show only active applications in Dock"
fi

execute "defaults write com.apple.dock show-process-indicators -bool true" \
    "Show application indicators"

execute "defaults write com.apple.dock launchanim -bool false" \
    "Disable opening application animations"

# Stack Settings
execute "defaults write com.apple.dock use-new-list-stack -bool true" \
    "Use the new style stack grid"

execute "defaults write com.apple.dock mouse-over-hilite-stack -bool true" \
    "Enable stack hover effect"

execute "defaults write com.apple.dock show-recently-used-items -bool false" \
    "Hide recent items in stacks"

# Mission Control
execute "defaults write com.apple.dock expose-animation-duration -float 0.1" \
    "Speed up Mission Control animations"

# Dashboard is deprecated in macOS Catalina and later
if [[ $(sw_vers -productVersion | cut -d. -f1) -lt 11 ]]; then
    execute "defaults write com.apple.dock dashboard-in-overlay -bool true" \
        "Don't show Dashboard as a Space"
else
    print_in_yellow "Note: Dashboard is no longer available in macOS Catalina and later
"
fi

execute "defaults write com.apple.dock expose-group-by-app -bool false" \
    "Don't group windows by application in Mission Control"

execute "defaults write com.apple.dock showAppExposeGestureEnabled -bool true" \
    "Enable App Exposé gesture"

execute "defaults write com.apple.dock showMissionControlGestureEnabled -bool true" \
    "Enable Mission Control gesture"

# Launchpad
execute "defaults write com.apple.dock springboard-columns -int 8" \
    "Set number of columns in Launchpad"

execute "defaults write com.apple.dock springboard-rows -int 7" \
    "Set number of rows in Launchpad"

execute "defaults write com.apple.dock springboard-show-duration -float 0.1" \
    "Speed up Launchpad show animation"

execute "defaults write com.apple.dock springboard-hide-duration -float 0.1" \
    "Speed up Launchpad hide animation"

execute "defaults write com.apple.dock ResetLaunchPad -bool true" \
    "Reset Launchpad layout"

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard (removed in macOS Catalina)
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# 14: Quick Note (macOS Monterey and later)

# Top left hot corner → Mission Control
execute "defaults write com.apple.dock wvous-tl-corner -int 2 && \
         defaults write com.apple.dock wvous-tl-modifier -int 0" \
    "Set top left hot corner to Mission Control"

# Top right hot corner → Desktop
execute "defaults write com.apple.dock wvous-tr-corner -int 4 && \
         defaults write com.apple.dock wvous-tr-modifier -int 0" \
    "Set top right hot corner to Desktop"

# Bottom left hot corner → Start screen saver
execute "defaults write com.apple.dock wvous-bl-corner -int 5 && \
         defaults write com.apple.dock wvous-bl-modifier -int 0" \
    "Set bottom left hot corner to Start screen saver"

# Quick Note is only available in macOS Monterey (12.0) and later
if [[ $(sw_vers -productVersion | cut -d. -f1) -ge 12 ]]; then
    # Bottom right hot corner → Quick Note
    execute "defaults write com.apple.dock wvous-br-corner -int 14 && \
             defaults write com.apple.dock wvous-br-modifier -int 0" \
        "Set bottom right hot corner to Quick Note"
else
    # Bottom right hot corner → Notification Center (fallback for older macOS)
    execute "defaults write com.apple.dock wvous-br-corner -int 12 && \
             defaults write com.apple.dock wvous-br-modifier -int 0" \
        "Set bottom right hot corner to Notification Center"
fi

# Restart Dock to apply changes
execute "killall Dock" \
    "Restart Dock"
