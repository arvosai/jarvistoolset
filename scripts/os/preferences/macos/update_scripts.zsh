#!/usr/bin/env zsh

# Script to update all preference scripts with version compatibility checks
# This script will add version compatibility checks to all .zsh scripts in the directory

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"

print_in_purple "
 >> Updating macOS preference scripts with version compatibility checks

"

# List of scripts to update (excluding main.zsh, dock.zsh, finder.zsh, and template.zsh which are already updated)
SCRIPTS=(
    "accessibility.zsh"
    "app_store.zsh"
    "bluetooth.zsh"
    "chrome.zsh"
    "dashboard.zsh"
    "date_time.zsh"
    "energy.zsh"
    "firefox.zsh"
    "icloud.zsh"
    "keyboard.zsh"
    "language.zsh"
    "language_and_region.zsh"
    "mail.zsh"
    "maps.zsh"
    "messages.zsh"
    "mission_control.zsh"
    "mouse.zsh"
    "music.zsh"
    "network.zsh"
    "notifications.zsh"
    "photos.zsh"
    "safari.zsh"
    "screen.zsh"
    "security.zsh"
    "sharing.zsh"
    "siri.zsh"
    "software_update.zsh"
    "sound.zsh"
    "spotlight.zsh"
    "system.zsh"
    "terminal.zsh"
    "textedit.zsh"
    "time_machine.zsh"
    "trackpad.zsh"
    "ui.zsh"
    "ui_and_ux.zsh"
    "users_groups.zsh"
)

# Version compatibility code to insert
VERSION_CHECK=$(cat << 'EOT'

# Minimum supported macOS version for this script
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    if ! is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_error "Your macOS version ($current_version) is not supported for these preferences"
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

EOT
)

# Update each script
for script in "${SCRIPTS[@]}"; do
    if [[ -f "$SCRIPT_DIR/$script" ]]; then
        print_in_yellow "Updating $script...
"
        
        # Create a temporary file
        TEMP_FILE=$(mktemp)
        
        # Read the script and insert the version check after the utils.zsh source line
        awk -v version_check="$VERSION_CHECK" '
        /^source.*utils.zsh/ {
            print $0;
            print "";
            print "# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -";
            print version_check;
            next;
        }
        /^# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -/ && !seen {
            seen = 1;
            next;
        }
        { print $0 }
        ' "$SCRIPT_DIR/$script" > "$TEMP_FILE"
        
        # Replace the original file with the updated one
        mv "$TEMP_FILE" "$SCRIPT_DIR/$script"
        chmod +x "$SCRIPT_DIR/$script"
        
        print_success "$script updated successfully"
    else
        print_error "Script $script not found"
    fi
done

print_in_purple "
 >> All preference scripts have been updated with version compatibility checks

"
print_in_yellow "Note: You may need to review each script for specific version-dependent settings.
"
