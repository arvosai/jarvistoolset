#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Setting macOS Preferences

"

# Close any open System Preferences panes to prevent them from overriding settings
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo_is_active

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer name (as done via System Preferences → Sharing)
if [[ -n "$HOSTNAME" ]]; then
    execute "sudo scutil --set ComputerName '$HOSTNAME'" "Setting computer name to $HOSTNAME"
    execute "sudo scutil --set HostName '$HOSTNAME'" "Setting host name to $HOSTNAME"
    execute "sudo scutil --set LocalHostName '$HOSTNAME'" "Setting local host name to $HOSTNAME"
    execute "sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string '$HOSTNAME'" "Setting NetBIOS name to $HOSTNAME"
fi

# Disable the sound effects on boot
execute "sudo nvram SystemAudioVolume=' '" "Disabling sound effects on boot"

# Set sidebar icon size to medium
execute "defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2" "Setting sidebar icon size to medium"

# Always show scrollbars
execute "defaults write NSGlobalDomain AppleShowScrollBars -string 'Always'" "Setting scrollbars to always show"

# Disable the "Are you sure you want to open this application?" dialog
execute "defaults write com.apple.LaunchServices LSQuarantine -bool false" "Disabling app launch warning dialog"

# Disable automatic termination of inactive apps
execute "defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true" "Disabling automatic termination of inactive apps"

# Save to disk (not to iCloud) by default
execute "defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false" "Setting default save location to local disk"

# Disable the crash reporter
execute "defaults write com.apple.CrashReporter DialogType -string 'none'" "Disabling crash reporter"

###############################################################################
# Finder                                                                      #
###############################################################################

# Show hidden files by default
execute "defaults write com.apple.finder AppleShowAllFiles -bool true" "Showing hidden files in Finder"

# Show all filename extensions
execute "defaults write NSGlobalDomain AppleShowAllExtensions -bool true" "Showing all filename extensions"

# Show status bar
execute "defaults write com.apple.finder ShowStatusBar -bool true" "Showing status bar in Finder"

# Show path bar
execute "defaults write com.apple.finder ShowPathbar -bool true" "Showing path bar in Finder"

# Display full POSIX path as Finder window title
execute "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true" "Displaying full path in Finder window title"

# Keep folders on top when sorting by name
execute "defaults write com.apple.finder _FXSortFoldersFirst -bool true" "Keeping folders on top when sorting by name"

# When performing a search, search the current folder by default
execute "defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'" "Setting search scope to current folder"

# Disable the warning when changing a file extension
execute "defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false" "Disabling warning when changing file extensions"

# Enable spring loading for directories
execute "defaults write NSGlobalDomain com.apple.springing.enabled -bool true" "Enabling spring loading for directories"

# Remove the spring loading delay for directories
execute "defaults write NSGlobalDomain com.apple.springing.delay -float 0" "Removing spring loading delay"

# Avoid creating .DS_Store files on network or USB volumes
execute "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true" "Avoiding .DS_Store files on network volumes"
execute "defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true" "Avoiding .DS_Store files on USB volumes"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Set the icon size of Dock items
execute "defaults write com.apple.dock tilesize -int 48" "Setting Dock icon size to 48 pixels"

# Change minimize/maximize window effect
execute "defaults write com.apple.dock mineffect -string 'scale'" "Setting window minimize effect to scale"

# Minimize windows into their application's icon
execute "defaults write com.apple.dock minimize-to-application -bool true" "Setting windows to minimize into app icon"

# Enable spring loading for all Dock items
execute "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true" "Enabling spring loading for all Dock items"

# Show indicator lights for open applications in the Dock
execute "defaults write com.apple.dock show-process-indicators -bool true" "Showing indicator lights for open applications"

# Don't animate opening applications from the Dock
execute "defaults write com.apple.dock launchanim -bool false" "Disabling opening application animations"

# Speed up Mission Control animations
execute "defaults write com.apple.dock expose-animation-duration -float 0.1" "Speeding up Mission Control animations"

# Don't group windows by application in Mission Control
execute "defaults write com.apple.dock expose-group-by-app -bool false" "Disabling window grouping in Mission Control"

# Don't automatically rearrange Spaces based on most recent use
execute "defaults write com.apple.dock mru-spaces -bool false" "Disabling automatic Space rearrangement"

# Remove the auto-hiding Dock delay
execute "defaults write com.apple.dock autohide-delay -float 0" "Removing auto-hiding Dock delay"

# Remove the animation when hiding/showing the Dock
execute "defaults write com.apple.dock autohide-time-modifier -float 0" "Removing Dock hiding/showing animation"

# Automatically hide and show the Dock
execute "defaults write com.apple.dock autohide -bool true" "Setting Dock to auto-hide"

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Only use UTF-8 in Terminal.app
execute "defaults write com.apple.terminal StringEncodings -array 4" "Setting Terminal to only use UTF-8"

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
execute "defaults write com.apple.terminal SecureKeyboardEntry -bool true" "Enabling Secure Keyboard Entry in Terminal"

# Disable the annoying line marks
execute "defaults write com.apple.Terminal ShowLineMarks -int 0" "Disabling line marks in Terminal"

###############################################################################
# Apply Changes                                                               #
###############################################################################

# Restart affected applications
for app in "Dock" "Finder" "SystemUIServer" "Terminal"; do
    killall "${app}" &> /dev/null
done

print_in_purple "
 >> macOS Preferences have been set

"
print_in_yellow "Note: Some of these changes require a logout/restart to take effect.
"
