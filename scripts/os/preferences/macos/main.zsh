#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
PREFS_DIR="$SCRIPT_DIR"

# Source the utility functions
source "${SCRIPT_DIR}/../../utils.zsh"

# Define the directory structure for preference scripts
PREFERENCE_SCRIPTS_DIR="$PREFS_DIR"

# Parse arguments
HOSTNAME="$1"
USERNAME="$2"
EMAIL="$3"
SELECTED_CATEGORIES="$4"

# Use DIRECTORY from environment if available, otherwise default
DIRECTORY=${DIRECTORY:-"$HOME/.jarvistoolset"}

# Print header
print_in_purple "
 >> macOS Preferences Configuration

"

# Define preference categories
typeset -A PREF_CATEGORIES
PREF_CATEGORIES=(
    "accessibility" "Accessibility settings"
    "app_store" "App Store settings"
    "bluetooth" "Bluetooth settings"
    "chrome" "Chrome browser settings"
    "dashboard" "Dashboard settings"
    "date_time" "Date and time settings"
    "dock" "Dock settings"
    "energy" "Energy and battery settings"
    "finder" "Finder settings"
    "firefox" "Firefox browser settings"
    "icloud" "iCloud settings"
    "keyboard" "Keyboard settings"
    "language" "Language settings"
    "mail" "Mail app settings"
    "mission_control" "Mission Control settings"
    "mouse" "Mouse settings"
    "network" "Network settings"
    "notifications" "Notification settings"
    "safari" "Safari browser settings"
    "screen" "Screen and display settings"
    "security" "Security and privacy settings"
    "sharing" "Sharing settings"
    "siri" "Siri settings"
    "software_update" "Software update settings"
    "sound" "Sound settings"
    "spotlight" "Spotlight settings"
    "system" "System settings"
    "terminal" "Terminal settings"
    "textedit" "TextEdit settings"
    "time_machine" "Time Machine settings"
    "trackpad" "Trackpad settings"
    "ui" "UI and UX settings"
)

# Ask user how they want to configure preferences
print_in_yellow "
How would you like to configure preferences?
"
print_in_yellow "0) Configure all preferences
"
print_in_yellow "1) Select specific categories
"
print_in_yellow "2) Skip all preferences

"

# Get user selection
choice=""
vared -p $'Enter your choice (0-2): ' choice

# Create array to store selected categories
typeset -A SELECTED_PREFS

# Initialize all to false
for category in ${(k)PREF_CATEGORIES}; do
    SELECTED_PREFS[$category]="false"
done

# Process user selection
if [[ "$choice" == "0" ]]; then
    # Select all categories
    for category in ${(k)PREF_CATEGORIES}; do
        SELECTED_PREFS[$category]="true"
    done
    print_in_green "
All preference categories selected
"
elif [[ "$choice" == "1" ]]; then
    # Custom selection
    print_in_yellow "
Select preference categories (enter y/n for each):
"
    
    for category in ${(k)PREF_CATEGORIES}; do
        category_choice=""
        vared -p $'Configure ${PREF_CATEGORIES[$category]}? (y/n): ' category_choice
        
        if [[ "$category_choice" =~ ^[Yy]$ ]]; then
            SELECTED_PREFS[$category]="true"
        fi
    done
elif [[ "$choice" == "2" ]]; then
    print_in_yellow "
Skipping all preferences
"
    exit 0
else
    print_in_red "
Invalid choice. No preferences will be configured.
"
    exit 1
fi

# Convert selected preferences to a comma-separated list if not already provided
if [[ -z "$SELECTED_CATEGORIES" ]]; then
    SELECTED_CATEGORIES=""
    for category in ${(k)SELECTED_PREFS}; do
        if [[ "${SELECTED_PREFS[$category]}" == "true" ]]; then
            if [[ -z "$SELECTED_CATEGORIES" ]]; then
                SELECTED_CATEGORIES="$category"
            else
                SELECTED_CATEGORIES="$SELECTED_CATEGORIES,$category"
            fi
        fi
    done
fi

# If no categories were selected, exit
if [[ -z "$SELECTED_CATEGORIES" ]]; then
    print_in_yellow "
No preferences selected. Skipping configuration.
"
    exit 0
fi

# Convert comma-separated list back to array for processing
IFS=',' read -rA CATEGORY_ARRAY <<< "$SELECTED_CATEGORIES"

# Function to run a preference script if it exists
run_preference_script() {
    local script="$1"
    if [[ -f "$script" && -x "$script" ]]; then
        print_in_yellow "Running $(basename "$script")...
"
        "$script"
    else
        print_in_red "Script not found or not executable: $script
"
    fi
}

# Process each preference category
print_in_purple "
 >> Configuring selected preferences

"

# System Preferences
for category in ${(k)PREF_CATEGORIES}; do
    script="$PREFERENCE_SCRIPTS_DIR/${category}.zsh"
    
    # Check if this category was selected
    if [[ " ${CATEGORY_ARRAY[@]} " =~ " $category " || "$SELECTED_CATEGORIES" == "all" ]]; then
        run_preference_script "$script"
    else
        script_name=$(basename "$script")
        print_in_red "Skipping $script_name (not selected)
"
    fi
done

print_in_purple "
 >> System preferences configuration completed

"

# Application Preferences
# Add application preferences scripts here if needed

print_in_purple "
 >> All selected preferences have been configured

"
print_in_yellow "Note: Some changes may require a system restart to take effect.
"

# Minimum supported macOS version
MINIMUM_MACOS_VERSION="14.0.0"  # macOS Sonoma

# Function to check macOS version compatibility
check_macos_compatibility() {
    local current_version=$(sw_vers -productVersion)
    
    print_in_yellow "
 >> Checking macOS version compatibility
"
    print_in_yellow "   Current macOS version: $current_version
"
    print_in_yellow "   Minimum supported version: $MINIMUM_MACOS_VERSION
"
    
    if is_supported_version "$current_version" "$MINIMUM_MACOS_VERSION"; then
        print_success "macOS version is compatible"
        return 0
    else
        print_error "Your macOS version ($current_version) is not supported"
        print_in_yellow "Please upgrade to macOS Sonoma ($MINIMUM_MACOS_VERSION) or later before running these preference scripts.
"
        return 1
    fi
}

# Function to run a preference script with error handling
run_preference_script_with_error_handling() {
    local script="$1"
    local script_name=$(basename "$script")
    
    if [[ -f "$script" && -x "$script" ]]; then
        print_in_yellow "Running $script_name...
"
        "$script" 2>/tmp/preference_error_$$.log
        
        if [[ $? -ne 0 ]]; then
            print_warning "Warning: $script_name encountered issues"
            if [[ -s /tmp/preference_error_$$.log ]]; then
                print_in_yellow "Error details:
"
                cat /tmp/preference_error_$$.log
            fi
        else
            print_success "$script_name completed successfully"
        fi
        
        rm -f /tmp/preference_error_$$.log
    else
        print_warning "Script $script_name not found or not executable"
    fi
}

# Special handling for UI and UX script with hostname parameter
if [[ -f "$PREFERENCE_SCRIPTS_DIR/ui_and_ux.zsh" && -x "$PREFERENCE_SCRIPTS_DIR/ui_and_ux.zsh" ]]; then
    if is_category_selected "UI"; then
        print_in_yellow "Running ui_and_ux.zsh with hostname parameter...
"
        "$PREFERENCE_SCRIPTS_DIR/ui_and_ux.zsh" "$HOSTNAME"
        print_success "ui_and_ux.zsh completed"
    else
        print_in_yellow "Skipping ui_and_ux.zsh (not selected)
"
    fi
fi

# Run users_groups script if selected
if [[ -f "$PREFERENCE_SCRIPTS_DIR/users_groups.zsh" && -x "$PREFERENCE_SCRIPTS_DIR/users_groups.zsh" ]]; then
    if is_category_selected "System"; then
        print_in_yellow "Running users_groups.zsh...
"
        "$PREFERENCE_SCRIPTS_DIR/users_groups.zsh"
        print_success "users_groups.zsh completed"
    else
        print_in_yellow "Skipping users_groups.zsh (not selected)
"
    fi
fi

# Check macOS compatibility before proceeding
if ! check_macos_compatibility; then
    print_in_red "
Aborting preferences configuration due to incompatible macOS version.
"
    exit 1
fi

# Close any open System Preferences panes to prevent
# overriding the preferences that are being changed.
if [[ -f "$PREFERENCE_SCRIPTS_DIR/close_system_preferences_panes.applescript" ]]; then
    print_in_yellow "Closing any open System Settings panes...
"
    "$PREFERENCE_SCRIPTS_DIR/close_system_preferences_panes.applescript"
else
    print_warning "close_system_preferences_panes.applescript not found"
fi

# Define all available preference scripts with their categories
typeset -A PREFERENCE_SCRIPTS
PREFERENCE_SCRIPTS=(
    "$PREFERENCE_SCRIPTS_DIR/accessibility.zsh" "Accessibility"
    "$PREFERENCE_SCRIPTS_DIR/app_store.zsh" "App Store"
    "$PREFERENCE_SCRIPTS_DIR/bluetooth.zsh" "Bluetooth"
    "$PREFERENCE_SCRIPTS_DIR/chrome.zsh" "Chrome"
    "$PREFERENCE_SCRIPTS_DIR/dashboard.zsh" "Dashboard"
    "$PREFERENCE_SCRIPTS_DIR/date_time.zsh" "Date and Time"
    "$PREFERENCE_SCRIPTS_DIR/dock.zsh" "Dock"
    "$PREFERENCE_SCRIPTS_DIR/energy.zsh" "Energy"
    "$PREFERENCE_SCRIPTS_DIR/finder.zsh" "Finder"
    "$PREFERENCE_SCRIPTS_DIR/firefox.zsh" "Firefox"
    "$PREFERENCE_SCRIPTS_DIR/icloud.zsh" "iCloud"
    "$PREFERENCE_SCRIPTS_DIR/keyboard.zsh" "Keyboard"
    "$PREFERENCE_SCRIPTS_DIR/language.zsh" "Language"
    "$PREFERENCE_SCRIPTS_DIR/language_and_region.zsh" "Language and Region"
    "$PREFERENCE_SCRIPTS_DIR/mail.zsh" "Mail"
    "$PREFERENCE_SCRIPTS_DIR/maps.zsh" "Maps"
    "$PREFERENCE_SCRIPTS_DIR/messages.zsh" "Messages"
    "$PREFERENCE_SCRIPTS_DIR/mission_control.zsh" "Mission Control"
    "$PREFERENCE_SCRIPTS_DIR/mouse.zsh" "Mouse"
    "$PREFERENCE_SCRIPTS_DIR/music.zsh" "Music"
    "$PREFERENCE_SCRIPTS_DIR/network.zsh" "Network"
    "$PREFERENCE_SCRIPTS_DIR/notifications.zsh" "Notifications"
    "$PREFERENCE_SCRIPTS_DIR/photos.zsh" "Photos"
    "$PREFERENCE_SCRIPTS_DIR/safari.zsh" "Safari"
    "$PREFERENCE_SCRIPTS_DIR/screen.zsh" "Screen"
    "$PREFERENCE_SCRIPTS_DIR/security.zsh" "Security"
    "$PREFERENCE_SCRIPTS_DIR/sharing.zsh" "Sharing"
    "$PREFERENCE_SCRIPTS_DIR/siri.zsh" "Siri"
    "$PREFERENCE_SCRIPTS_DIR/software_update.zsh" "Software Update"
    "$PREFERENCE_SCRIPTS_DIR/sound.zsh" "Sound"
    "$PREFERENCE_SCRIPTS_DIR/spotlight.zsh" "Spotlight"
    "$PREFERENCE_SCRIPTS_DIR/system.zsh" "System"
    "$PREFERENCE_SCRIPTS_DIR/terminal.zsh" "Terminal"
    "$PREFERENCE_SCRIPTS_DIR/textedit.zsh" "TextEdit"
    "$PREFERENCE_SCRIPTS_DIR/time_machine.zsh" "Time Machine"
    "$PREFERENCE_SCRIPTS_DIR/trackpad.zsh" "Trackpad"
    "$PREFERENCE_SCRIPTS_DIR/ui.zsh" "UI"
)

# Run selected preference scripts
for script in ${(k)PREFERENCE_SCRIPTS}; do
    category="${PREFERENCE_SCRIPTS[$script]}"
    
    if is_category_selected "$category"; then
        run_preference_script_with_error_handling "$script"
    else
        script_name=$(basename "$script")
        print_in_red "Skipping $script_name (not selected)
"
    fi
done

print_in_purple "
 >> System preferences configuration completed

"

# Application Preferences
# Add application preferences scripts here if needed

print_in_purple "
 >> All selected preferences have been configured

"
print_in_yellow "Note: Some changes may require a system restart to take effect.
"
