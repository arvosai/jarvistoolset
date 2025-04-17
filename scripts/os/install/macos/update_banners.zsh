#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}

# Source the utils files with absolute paths to avoid path issues
source "${SCRIPT_DIR}/../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create a banner for this script
create_figlet_banner "UPDATE BANNERS"

# Function to update a script with the figlet banner
update_script_banner() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    # Skip the update_banners.zsh script itself and template.zsh
    if [[ "$script_name" == "update_banners.zsh" || "$script_name" == "template.zsh" ]]; then
        return 0
    fi
    
    echo "Updating banner for: $script_path"
    
    # Check if the script already has the banner
    if grep -q "create_install_banner" "$script_path"; then
        print_success "Script $script_path already has a banner. Skipping."
        return 0
    fi
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Read the script file
    local script_content=$(cat "$script_path")
    
    # Check if the script has a source statement for utils.zsh
    if ! echo "$script_content" | grep -q "source.*utils.zsh"; then
        print_error "Script $script_path does not source utils.zsh. Skipping."
        return 1
    fi
    
    # Check if the script already sources the macos/utils.zsh file
    if ! echo "$script_content" | grep -q "source.*macos/utils.zsh"; then
        # Add the source statement for the macos/utils.zsh file
        script_content=$(echo "$script_content" | awk '
        /source.*utils.zsh/ {
            print $0;
            print "source \"${SCRIPT_DIR}/../utils.zsh\"";
            next;
        }
        { print $0; }
        ')
    fi
    
    # Add the banner after the separator line
    script_content=$(echo "$script_content" | awk '
    BEGIN { found = 0; }
    
    /^# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$/ && !found {
        print $0;
        print "";
        print "# Create a banner for this installation script";
        print "create_install_banner \"$0\"";
        print "";
        found = 1;
        next;
    }
    
    { print $0; }
    ')
    
    # Write the modified content back to the temporary file
    echo "$script_content" > "$temp_file"
    
    # Replace the original file with the modified one
    mv "$temp_file" "$script_path"
    chmod +x "$script_path"
    
    print_success "Updated banner for: $script_path"
}

# Only update scripts in the dev_langs directory as a demonstration
find "$SCRIPT_DIR/dev_langs" -type f -name "*.zsh" | while read -r script; do
    update_script_banner "$script"
done

print_in_purple "\n >> Installation scripts in dev_langs directory have been updated with figlet banners!\n\n"

# Test one of the scripts to see the banner
echo "Testing a script to see the banner:"
echo "-----------------------------------"
"$SCRIPT_DIR/dev_langs/cpp.zsh" --dry-run 2>/dev/null || true

echo "\nTo update the figlet font, you can install additional fonts:"
echo "brew install figlet-fonts"
