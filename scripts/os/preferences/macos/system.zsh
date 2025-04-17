#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures system tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Minimum supported macOS version for this script
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    if ! is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_error "Your macOS version ($current_version) is not supported for System preferences"
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
   System

"

# Ensure sudo is available for privileged operations
sudo_is_active

# General System Settings
print_in_yellow "
 >> Configuring General System Settings
"

# Set computer name (as done via System Preferences → Sharing)
COMPUTER_NAME="jarvis-mac"
execute "sudo scutil --set ComputerName '$COMPUTER_NAME'" \
    "Set computer name to $COMPUTER_NAME"
execute "sudo scutil --set HostName '$COMPUTER_NAME'" \
    "Set host name to $COMPUTER_NAME"
execute "sudo scutil --set LocalHostName '$COMPUTER_NAME'" \
    "Set local host name to $COMPUTER_NAME"
execute "sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string '$COMPUTER_NAME'" \
    "Set NetBIOS name to $COMPUTER_NAME"

# Set standby delay to 24 hours (default is 1 hour)
execute "sudo pmset -a standbydelay 86400" \
    "Set standby delay to 24 hours"

# Disable the sound effects on boot
execute "sudo nvram SystemAudioVolume=' '" \
    "Disable the sound effects on boot"

# Disable transparency in the menu bar and elsewhere
execute "defaults write com.apple.universalaccess reduceTransparency -bool true" \
    "Disable transparency"

# Increase window resize speed for Cocoa applications
execute "defaults write NSGlobalDomain NSWindowResizeTime -float 0.001" \
    "Increase window resize speed"

# Expand save panel by default
execute "defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true" \
    "Expand save panel by default"
execute "defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true" \
    "Expand save panel by default (2)"

# Expand print panel by default
execute "defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true" \
    "Expand print panel by default"
execute "defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true" \
    "Expand print panel by default (2)"

# Save to disk (not to iCloud) by default
execute "defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false" \
    "Save to disk by default"

# Automatically quit printer app once the print jobs complete
execute "defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true" \
    "Automatically quit printer app"

# Disable the "Are you sure you want to open this application?" dialog
execute "defaults write com.apple.LaunchServices LSQuarantine -bool false" \
    "Disable app opening confirmation dialog"

# Disable Resume system-wide
execute "defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false" \
    "Disable Resume system-wide"

# Disable automatic termination of inactive apps
execute "defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true" \
    "Disable automatic termination of inactive apps"

# Disable the crash reporter
execute "defaults write com.apple.CrashReporter DialogType -string 'none'" \
    "Disable the crash reporter"

# Disable Notification Center and remove the menu bar icon
if [[ $MACOS_MAJOR_VERSION -lt 14 ]]; then
    # This command may not work in macOS Sonoma
    execute "launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null" \
        "Disable Notification Center (pre-Sonoma)"
else
    print_in_yellow "Note: In macOS Sonoma, Notification Center cannot be completely disabled via command line
"
    print_in_yellow "Configure notification settings in System Settings > Notifications
"
fi

# Disable automatic capitalization
execute "defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false" \
    "Disable automatic capitalization"

# Disable smart dashes
execute "defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false" \
    "Disable smart dashes"

# Disable automatic period substitution
execute "defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false" \
    "Disable automatic period substitution"

# Disable smart quotes
execute "defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false" \
    "Disable smart quotes"

# Disable auto-correct
execute "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false" \
    "Disable auto-correct"

# Power Management Settings
print_in_yellow "
 >> Configuring Power Management Settings
"

# Sleep settings
execute "sudo pmset -a displaysleep 15" \
    "Set display sleep to 15 minutes"

execute "sudo pmset -a sleep 30" \
    "Set system sleep to 30 minutes"

execute "sudo pmset -a disksleep 10" \
    "Set disk sleep to 10 minutes"

# Power settings
execute "sudo pmset -a lidwake 1" \
    "Wake when lid is opened"

execute "sudo pmset -a autorestart 1" \
    "Automatically restart on power loss"

execute "sudo pmset -a autopoweroff 0" \
    "Disable autopoweroff"

execute "sudo pmset -a hibernatemode 3" \
    "Set hibernatemode to 3 (safe sleep)"

# Performance Settings
print_in_yellow "
 >> Configuring Performance Settings
"

# Disable sudden motion sensor (not needed for SSDs)
execute "sudo pmset -a sms 0" \
    "Disable sudden motion sensor"

# Disable hibernation (speeds up entering sleep mode)
execute "sudo pmset -a hibernatemode 0" \
    "Disable hibernation"

# Remove the sleep image file to save disk space
execute "sudo rm -f /private/var/vm/sleepimage" \
    "Remove sleep image file"

# Create a zero-byte file instead
execute "sudo touch /private/var/vm/sleepimage" \
    "Create empty sleep image file"

# Make sure it can't be rewritten
execute "sudo chflags uchg /private/var/vm/sleepimage" \
    "Secure sleep image file"

# Disable motion sensor (useful for SSDs)
execute "sudo pmset -a sms 0" \
    "Disable motion sensor"

# System UI Settings
print_in_yellow "
 >> Configuring System UI Settings
"

# Menu bar: show battery percentage
execute "defaults write com.apple.menuextra.battery ShowPercent -string 'YES'" \
    "Show battery percentage in menu bar"

# Menu bar: hide the Time Machine, Volume, and User icons
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    print_in_yellow "Note: In macOS Sonoma, menu bar items are configured in Control Center settings
"
else
    execute "defaults write com.apple.systemuiserver menuExtras -array \
        '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' \
        '/System/Library/CoreServices/Menu Extras/AirPort.menu' \
        '/System/Library/CoreServices/Menu Extras/Battery.menu' \
        '/System/Library/CoreServices/Menu Extras/Clock.menu'" \
        "Configure menu bar items (pre-Sonoma)"
fi

# Set highlight color to green
execute "defaults write NSGlobalDomain AppleHighlightColor -string '0.764700 0.976500 0.568600'" \
    "Set highlight color to green"

# Set sidebar icon size to medium
execute "defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2" \
    "Set sidebar icon size to medium"

# Always show scrollbars
execute "defaults write NSGlobalDomain AppleShowScrollBars -string 'Always'" \
    "Always show scrollbars"

# Disable the over-the-top focus ring animation
execute "defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false" \
    "Disable focus ring animation"

# Adjust toolbar title rollover delay
execute "defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0" \
    "Adjust toolbar title rollover delay"

# Increase sound quality for Bluetooth headphones/headsets
execute "defaults write com.apple.BluetoothAudioAgent 'Apple Bitpool Min (editable)' -int 40" \
    "Increase Bluetooth audio quality"

# Enable full keyboard access for all controls
execute "defaults write NSGlobalDomain AppleKeyboardUIMode -int 3" \
    "Enable full keyboard access for all controls"

# Use scroll gesture with the Ctrl (^) modifier key to zoom
execute "defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true" \
    "Enable scroll gesture with Ctrl key to zoom"

execute "defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144" \
    "Set zoom modifier key to Ctrl"

# Follow the keyboard focus while zoomed in
execute "defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true" \
    "Follow keyboard focus while zoomed in"

# Set language and text formats
execute "defaults write NSGlobalDomain AppleLanguages -array 'en-US'" \
    "Set language to English (US)"

execute "defaults write NSGlobalDomain AppleLocale -string 'en_US@currency=USD'" \
    "Set locale to en_US"

execute "defaults write NSGlobalDomain AppleMeasurementUnits -string 'Inches'" \
    "Set measurement units to inches"

execute "defaults write NSGlobalDomain AppleMetricUnits -bool false" \
    "Use imperial units"

# Show language menu in the top right corner of the boot screen
execute "sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true" \
    "Show language menu on login screen"

# Set the timezone (see `sudo systemsetup -listtimezones` for other values)
execute "sudo systemsetup -settimezone 'America/New_York'" \
    "Set timezone to America/New_York"

# Stop iTunes from responding to the keyboard media keys
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    print_in_yellow "Note: In macOS Sonoma, media key behavior is configured in System Settings > Keyboard
"
else
    execute "launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null" \
        "Stop iTunes from responding to media keys (pre-Sonoma)"
fi

# Restart affected applications
print_in_yellow "
 >> Applying changes and restarting services
"

execute "killall Finder" \
    "Restart Finder"

execute "killall SystemUIServer" \
    "Restart SystemUIServer"

execute "killall Dock" \
    "Restart Dock"

print_success "System preferences have been configured"
print_in_yellow "Note: Some system settings may require a system restart to take effect.
"
