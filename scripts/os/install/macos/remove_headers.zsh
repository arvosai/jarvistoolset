#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}

# Create a banner for this script
echo "Removing create_framed_header calls from all scripts..."

# Function to process all scripts in a directory and its subdirectories
process_scripts_in_dir() {
    local dir="$1"
    
    echo "Processing scripts in: $dir"
    
    # Find all zsh scripts in the directory
    find "$dir" -maxdepth 1 -type f -name "*.zsh" | while read -r script; do
        # Skip the utility scripts
        if [[ "$script" == *"update_headers.zsh"* || "$script" == *"update_banners.zsh"* || 
              "$script" == *"template.zsh"* || "$script" == *"utils.zsh"* || 
              "$script" == *"remove_headers.zsh"* ]]; then
            echo "Skipping utility script: $script"
            continue
        fi
        
        echo "Removing header calls from: $script"
        
        # Create a temporary file
        local temp_file=$(mktemp)
        
        # Remove all create_framed_header lines and any empty lines that follow the separator line
        awk '
        BEGIN { skip_empty = 0; }
        
        /^# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$/ { 
            print $0; 
            skip_empty = 1; 
            next;
        }
        
        /^$/ && skip_empty { next; }
        
        /^# Create framed header/ { next; }
        
        /create_framed_header/ { next; }
        
        { 
            skip_empty = 0; 
            print $0;
        }
        ' "$script" > "$temp_file"
        
        # Replace the original file with the modified one
        mv "$temp_file" "$script"
        chmod +x "$script"
        
        echo "Removed header calls from: $script"
    done
}

# Process all scripts in the macOS installation directory and its subdirectories
find "$SCRIPT_DIR" -type d | while read -r dir; do
    process_scripts_in_dir "$dir"
done

echo "All create_framed_header calls have been removed from the scripts!"
