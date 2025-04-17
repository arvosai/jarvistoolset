#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures finder tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Minimum supported macOS version for this script
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    if ! is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_error "Your macOS version ($current_version) is not supported for Finder preferences"
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
   Finder

"

# Finder Window Settings
execute "defaults write com.apple.finder ShowStatusBar -bool true" \
    "Show status bar"

execute "defaults write com.apple.finder ShowPathbar -bool true" \
    "Show path bar"

execute "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true" \
    "Show full POSIX path in window title"

execute "defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true" \
    "Show external hard drives on desktop"

execute "defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true" \
    "Show hard drives on desktop"

execute "defaults write com.apple.finder ShowMountedServersOnDesktop -bool true" \
    "Show mounted servers on desktop"

execute "defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true" \
    "Show removable media on desktop"

# Finder Behavior
execute "defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true && \
         defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true && \
         defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true" \
    "Automatically open a new Finder window when a volume is mounted"

execute "defaults write com.apple.finder DisableAllAnimations -bool true" \
    "Disable animations"

execute "defaults write com.apple.finder WarnOnEmptyTrash -bool false" \
    "Disable warning before emptying Trash"

execute "defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'" \
    "Search current folder by default"

execute "defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false" \
    "Disable warning when changing file extension"

# View Settings
execute "defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'" \
    "Use list view in all Finder windows"

execute "defaults write com.apple.finder ShowRecentTags -bool false" \
    "Hide recent tags"

execute "defaults write com.apple.finder SidebarWidth -int 175" \
    "Set sidebar width"

execute "defaults write com.apple.finder ShowSidebar -bool true" \
    "Show sidebar"

execute "defaults write com.apple.finder ShowPreviewPane -bool true" \
    "Show preview pane"

# Tab view setting might be different in newer macOS versions
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    execute "defaults write com.apple.finder ShowTabBar -bool true" \
        "Show tab bar (Sonoma syntax)"
else
    execute "defaults write com.apple.finder ShowTabView -bool true" \
        "Show tab bar (pre-Sonoma syntax)"
fi

# Advanced Settings
execute "defaults write com.apple.finder AppleShowAllFiles -bool true" \
    "Show hidden files"

execute "defaults write com.apple.finder FXInfoPanesExpanded -dict \
         General -bool true \
         OpenWith -bool true \
         Preview -bool true \
         Privileges -bool true" \
    "Expand info panes"

execute "defaults write com.apple.finder ShowPreviewPane -bool true" \
    "Show preview pane"

execute "defaults write com.apple.finder _FXSortFoldersFirst -bool true" \
    "Keep folders on top when sorting by name"

# This setting might have changed in newer macOS versions
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    execute "defaults write com.apple.finder FXRemoveOldTrashItems -bool true" \
        "Remove items from Trash after 30 days"
    print_in_yellow "Note: Trash auto-removal settings may also be controlled via System Settings in Sonoma
"
else
    execute "defaults write com.apple.finder FXRemoveOldTrashItems -bool true" \
        "Remove items from Trash after 30 days"
fi

execute "defaults write com.apple.finder FXPreferredGroupBy -string 'Name'" \
    "Group items by name"

execute "defaults write com.apple.finder CreateDesktop -bool true" \
    "Show desktop icons"

execute "defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true" \
    "Show hard drives on desktop"

# New Window Settings
execute "defaults write com.apple.finder NewWindowTarget -string 'PfHm'" \
    "Set new window target to Home folder"

execute "defaults write com.apple.finder NewWindowTargetPath -string 'file://${HOME}'" \
    "Set new window path to Home folder"

# File Operations
execute "defaults write com.apple.finder QLEnableTextSelection -bool true" \
    "Enable text selection in Quick Look"

# iCloud Drive settings may have changed in newer macOS versions
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    print_in_yellow "Note: iCloud Drive settings may need to be configured via System Settings in Sonoma
"
    execute "defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false" \
        "Disable warning when removing from iCloud Drive"
else
    execute "defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false" \
        "Disable warning when removing from iCloud Drive"
    execute "defaults write com.apple.finder FXICloudDriveDesktop -bool true" \
        "Enable iCloud Drive desktop sync"
    execute "defaults write com.apple.finder FXICloudDriveDocuments -bool true" \
        "Enable iCloud Drive documents sync"
fi

# Sidebar Settings - these may have changed in newer macOS versions
if [[ $MACOS_MAJOR_VERSION -ge 14 ]]; then
    print_in_yellow "Note: Some sidebar settings may need to be configured via System Settings in Sonoma
"
    execute "defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true" \
        "Expand Devices section in sidebar"
    execute "defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true" \
        "Expand Places section in sidebar"
else
    execute "defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true" \
        "Expand Devices section in sidebar"
    execute "defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true" \
        "Expand Places section in sidebar"
    execute "defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool true" \
        "Show iCloud Drive in sidebar"
    execute "defaults write com.apple.finder SidebarShowAllTags -bool false" \
        "Hide All Tags in sidebar"
fi

# Search Settings
execute "defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'" \
    "Search the current folder by default"

execute "defaults write com.apple.finder FinderSpawnTab -bool false" \
    "Don't spawn a new tab for search results"

execute "defaults write com.apple.finder FXPreferredSearchViewStyle -string 'Nlsv'" \
    "Use list view for search results"

# Column View Settings
execute "defaults write com.apple.finder FK_DefaultColumnViewSettings -dict \
         ColumnShowIcons -bool true \
         ColumnWidth -int 250 \
         PreviewColumnVisible -bool true \
         ShowPreview -bool true" \
    "Configure column view settings"

# List View Settings
execute "defaults write com.apple.finder FK_DefaultListViewSettings -dict \
         CalculateFolderSizes -bool true \
         IconSize -int 16 \
         ShowPreview -bool true \
         UseRelativeDates -bool true" \
    "Configure list view settings"

# Icon View Settings
execute "defaults write com.apple.finder FK_DefaultIconViewSettings -dict \
         arrangeBy -string 'name' \
         gridSpacing -int 54 \
         iconSize -int 64 \
         labelOnBottom -bool true \
         showItemInfo -bool true \
         showIconPreview -bool true" \
    "Configure icon view settings"

# Restart Finder
execute "killall Finder" \
    "Restart Finder"

# Clean up
execute "defaults write com.apple.finder FXRecentFolders '()'" \
    "Clear recent folders"

# Since macOS Mavericks, preferences are cached,
# So for settings to be properly configured using `PlistBuddy`,
# The `cfprefsd` process also needs to be killed.
execute "killall cfprefsd" \
    "Restart preferences daemon"
