#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures security tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Minimum supported macOS version for this script
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    if ! is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_error "Your macOS version ($current_version) is not supported for Security preferences"
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
   Security

"

# Ensure sudo is available for privileged operations
sudo_is_active

# General Security Settings
print_in_yellow "
 >> Configuring General Security Settings
"

# Enable FileVault if not already enabled
if ! fdesetup isactive >/dev/null; then
    print_in_yellow "FileVault is not enabled. It's recommended to enable it via System Settings > Privacy & Security.
"
    print_in_yellow "This script will not automatically enable FileVault as it requires user interaction.
"
else
    print_success "FileVault is already enabled"
fi

# Enable Firewall
execute "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on" \
    "Enable Firewall"

# Enable Stealth Mode (don't respond to ICMP ping requests)
execute "sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on" \
    "Enable Firewall Stealth Mode"

# Disable automatic login
execute "sudo defaults write /Library/Preferences/com.apple.loginwindow autoLoginUser -bool false" \
    "Disable automatic login"

# Require password immediately after sleep or screen saver begins
execute "defaults write com.apple.screensaver askForPassword -bool true" \
    "Require password after sleep or screen saver"

execute "defaults write com.apple.screensaver askForPasswordDelay -int 0" \
    "Require password immediately"

# Disable IR remote control
execute "sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false" \
    "Disable IR remote control"

# Disable guest account
execute "sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false" \
    "Disable guest account"

# Disable sharing of local printers with other computers
execute "cupsctl --no-share-printers" \
    "Disable printer sharing"

# Disable Bonjour multicast advertising
execute "sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true" \
    "Disable Bonjour multicast advertising"

# Application Security Settings
print_in_yellow "
 >> Configuring Application Security Settings
"

# Enable Gatekeeper
execute "sudo spctl --master-enable" \
    "Enable Gatekeeper"

# Enable app verification
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    # macOS Sonoma specific settings
    execute "sudo defaults write /Library/Preferences/com.apple.security.assessment.plist AllowIdentifiedDevelopers -bool true" \
        "Allow apps from identified developers (Sonoma)"
else
    execute "sudo defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool true" \
        "Enable app verification (pre-Sonoma)"
fi

# Safari Security Settings
print_in_yellow "
 >> Configuring Safari Security Settings
"

# Disable Safari's thumbnail cache for History and Top Sites
execute "defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2" \
    "Disable Safari's thumbnail cache"

# Enable Safari's debug menu
execute "defaults write com.apple.Safari IncludeInternalDebugMenu -bool true" \
    "Enable Safari's debug menu"

# Make Safari's search banners default to Contains instead of Starts With
execute "defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false" \
    "Set Safari search to Contains"

# Enable the Develop menu and the Web Inspector in Safari
execute "defaults write com.apple.Safari IncludeDevelopMenu -bool true" \
    "Enable Safari Develop menu"

execute "defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true" \
    "Enable Safari WebKit developer extras"

execute "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true" \
    "Enable Safari WebKit2 developer extras"

# Warn about fraudulent websites
execute "defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true" \
    "Warn about fraudulent websites"

# Disable Java
execute "defaults write com.apple.Safari WebKitJavaEnabled -bool false" \
    "Disable Java in Safari"

execute "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false" \
    "Disable Java in Safari WebKit2"

# Block pop-up windows
execute "defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false" \
    "Block pop-up windows in Safari"

execute "defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false" \
    "Block pop-up windows in Safari WebKit2"

# Enable Do Not Track
execute "defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true" \
    "Enable Do Not Track in Safari"

# Update extensions automatically
execute "defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true" \
    "Update Safari extensions automatically"

# Privacy Settings
print_in_yellow "
 >> Configuring Privacy Settings
"

# Disable sending Safari search queries to Apple
execute "defaults write com.apple.Safari UniversalSearchEnabled -bool false" \
    "Disable sending Safari search queries to Apple"

execute "defaults write com.apple.Safari SuppressSearchSuggestions -bool true" \
    "Disable Safari search suggestions"

# Disable analytics data submission
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    print_in_yellow "Note: In macOS Sonoma, analytics settings are managed in System Settings > Privacy & Security > Analytics & Improvements
"
else
    execute "defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist AutoSubmit -bool false" \
        "Disable automatic submission of diagnostic reports"
    
    execute "defaults write /Library/Application\ Support/CrashReporter/DiagnosticMessagesHistory.plist ThirdPartyDataSubmit -bool false" \
        "Disable third-party diagnostic data submission"
fi

# Disable location services for Spotlight suggestions
execute "defaults write com.apple.safari.spotlighthelper LocationServicesEnabled -bool false" \
    "Disable location services for Spotlight suggestions"

# Network Security
print_in_yellow "
 >> Configuring Network Security Settings
"

# Disable wake on network access
execute "sudo pmset -a womp 0" \
    "Disable wake on network access"

# Disable remote login (SSH)
execute "sudo systemsetup -setremotelogin off" \
    "Disable remote login (SSH)"

# Disable remote Apple events
execute "sudo systemsetup -setremoteappleevents off" \
    "Disable remote Apple events"

# Disable Bluetooth sharing
execute "defaults write com.apple.Bluetooth PrefKeyServicesEnabled -bool false" \
    "Disable Bluetooth sharing"

# Disable AirDrop
execute "defaults write com.apple.NetworkBrowser DisableAirDrop -bool true" \
    "Disable AirDrop"

# Disable automatic joining of WiFi networks
execute "defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences RememberRecentNetworks -bool false" \
    "Disable automatic joining of WiFi networks"

execute "defaults write /Library/Preferences/SystemConfiguration/com.apple.airport.preferences JoinMode -string 'Preferred'" \
    "Set WiFi join mode to Preferred"

# Time Machine Security
print_in_yellow "
 >> Configuring Time Machine Security Settings
"

# Disable Time Machine prompts to use new hard drives as backup volume
execute "defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true" \
    "Disable Time Machine new disk prompts"

# Disable local Time Machine backups
execute "sudo tmutil disablelocal" \
    "Disable local Time Machine backups"

# Restart affected services
print_in_yellow "
 >> Applying changes and restarting services
"

execute "killall Finder" \
    "Restart Finder"

execute "killall SystemUIServer" \
    "Restart SystemUIServer"

print_success "Security preferences have been configured"
print_in_yellow "Note: Some security settings may require a system restart to take effect.
"
print_in_yellow "Note: Some settings may need to be manually configured in System Settings > Privacy & Security.
"
