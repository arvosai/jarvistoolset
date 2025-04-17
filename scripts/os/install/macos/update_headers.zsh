#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}

# Source the utils files with absolute paths to avoid path issues
source "${SCRIPT_DIR}/../utils.zsh" 2>/dev/null || true
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create a banner for this script
create_figlet_banner "UPDATE HEADERS"

# Process all scripts in the macOS installation directory and its subdirectories
echo "Processing scripts in macOS installation directory and subdirectories"

# Find all subdirectories in the macOS directory
find "$SCRIPT_DIR" -type d | while read -r dir; do
    echo "Checking directory: $dir"
    
    # Find all zsh scripts in the current directory
    find "$dir" -maxdepth 1 -type f -name "*.zsh" | while read -r script; do
        # Skip the update scripts themselves
        if [[ "$script" == *"update_headers.zsh"* || "$script" == *"update_banners.zsh"* || "$script" == *"template.zsh"* || "$script" == *"utils.zsh"* ]]; then
            echo "Skipping utility script: $script"
            continue
        fi
        
        # Add framed header to the script
        add_framed_header_to_script "$script"
    done
done

print_in_purple "\n >> All installation scripts have been updated with framed headers!\n\n"

# Test one of the scripts to see the framed header
echo "Testing a script to see the framed header:"
echo "-----------------------------------"
"$SCRIPT_DIR/dev_langs/cpp.zsh" --dry-run 2>/dev/null || true
