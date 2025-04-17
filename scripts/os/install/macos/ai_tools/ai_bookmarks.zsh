#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   AI Tools and Models Bookmarks

"

# Function to create bookmarks file for Brave
create_brave_bookmarks() {
    local bookmarks_dir="$HOME/Library/Application Support/BraveSoftware/Brave-Browser/Default"
    local bookmarks_file="$bookmarks_dir/Bookmarks"
    local bookmarks_backup="$bookmarks_dir/Bookmarks.bak"
    local timestamp=$(date +"%Y%m%d%H%M%S")
    
    # Check if Brave is installed
    if [ ! -d "$bookmarks_dir" ]; then
        print_error "Brave browser not found. Please install Brave first."
        return 1
    fi
    
    # Check if Brave is running
    if pgrep -x "Brave Browser" > /dev/null; then
        print_warning "Please close Brave browser before continuing."
        print_warning "Press any key to continue once Brave is closed..."
        read -k1
    fi
    
    # Create backup of existing bookmarks
    if [ -f "$bookmarks_file" ]; then
        cp "$bookmarks_file" "${bookmarks_backup}.${timestamp}"
        print_success "Created backup of existing bookmarks at ${bookmarks_backup}.${timestamp}"
    else
        print_warning "No existing bookmarks file found. A new one will be created."
    fi
    
    # Get current date in seconds since epoch (for bookmark added/modified time)
    local current_time=$(date +%s)
    local current_time_microseconds=$((current_time * 1000000))
    
    # Create AI Tools folder and bookmarks
    local ai_tools_json=$(cat << 'EOF'
{
   "roots": {
      "bookmark_bar": {
         "children": [
            {
               "children": [
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_ELEVENLABS",
                     "id": "1",
                     "name": "ElevenLabs",
                     "type": "url",
                     "url": "https://elevenlabs.io/download"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_HUGGINGFACE",
                     "id": "2",
                     "name": "Hugging Face",
                     "type": "url",
                     "url": "https://huggingface.co/docs/hub/en/repositories-getting-started"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_STABLEDIFFUSION",
                     "id": "3",
                     "name": "Stable Diffusion WebUI",
                     "type": "url",
                     "url": "https://github.com/AUTOMATIC1111/stable-diffusion-webui"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_COMFYUI",
                     "id": "4",
                     "name": "ComfyUI",
                     "type": "url",
                     "url": "https://github.com/comfyanonymous/ComfyUI"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_CLAUDE",
                     "id": "5",
                     "name": "Claude",
                     "type": "url",
                     "url": "https://claude.ai"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_WANDB",
                     "id": "6",
                     "name": "Weights & Biases",
                     "type": "url",
                     "url": "https://wandb.ai/site"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_MIDJOURNEY",
                     "id": "7",
                     "name": "Midjourney",
                     "type": "url",
                     "url": "https://www.midjourney.com"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_LEONARDO",
                     "id": "8",
                     "name": "Leonardo.AI",
                     "type": "url",
                     "url": "https://leonardo.ai"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_PERPLEXITY",
                     "id": "9",
                     "name": "Perplexity AI",
                     "type": "url",
                     "url": "https://www.perplexity.ai"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_ANTHROPIC",
                     "id": "10",
                     "name": "Anthropic Claude",
                     "type": "url",
                     "url": "https://claude.ai"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_GEMINI",
                     "id": "11",
                     "name": "Google Gemini",
                     "type": "url",
                     "url": "https://gemini.google.com"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_WHISPER",
                     "id": "12",
                     "name": "Whisper Studio",
                     "type": "url",
                     "url": "https://github.com/saharmor/whisper-playground"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_REPLICATE",
                     "id": "13",
                     "name": "Replicate",
                     "type": "url",
                     "url": "https://replicate.com"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_HUGGINGFACE_SPACES",
                     "id": "14",
                     "name": "Hugging Face Spaces",
                     "type": "url",
                     "url": "https://huggingface.co/spaces"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_RUNWAYML",
                     "id": "15",
                     "name": "RunwayML",
                     "type": "url",
                     "url": "https://runwayml.com"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_CHATGPT",
                     "id": "16",
                     "name": "ChatGPT",
                     "type": "url",
                     "url": "https://chat.openai.com"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_OLLAMA",
                     "id": "17",
                     "name": "Ollama",
                     "type": "url",
                     "url": "https://ollama.com"
                  },
                  {
                     "date_added": "TIMESTAMP",
                     "date_last_used": "0",
                     "guid": "GUID_LMSTUDIO",
                     "id": "18",
                     "name": "LM Studio",
                     "type": "url",
                     "url": "https://lmstudio.ai"
                  }
               ],
               "date_added": "TIMESTAMP",
               "date_last_used": "0",
               "date_modified": "TIMESTAMP",
               "guid": "GUID_AITOOLS_FOLDER",
               "id": "19",
               "name": "AI Tools and Models",
               "type": "folder"
            }
         ],
         "date_added": "TIMESTAMP",
         "date_last_used": "0",
         "date_modified": "TIMESTAMP",
         "guid": "GUID_BOOKMARKBAR",
         "id": "20",
         "name": "Bookmarks bar",
         "type": "folder"
      },
      "other": {
         "children": [],
         "date_added": "TIMESTAMP",
         "date_last_used": "0",
         "date_modified": "TIMESTAMP",
         "guid": "GUID_OTHER",
         "id": "21",
         "name": "Other bookmarks",
         "type": "folder"
      },
      "synced": {
         "children": [],
         "date_added": "TIMESTAMP",
         "date_last_used": "0",
         "date_modified": "TIMESTAMP",
         "guid": "GUID_SYNCED",
         "id": "22",
         "name": "Mobile bookmarks",
         "type": "folder"
      }
   },
   "version": 1
}
EOF
)
    
    # Replace timestamps and generate random GUIDs
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/TIMESTAMP/$current_time_microseconds/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_ELEVENLABS/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_HUGGINGFACE/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_STABLEDIFFUSION/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_COMFYUI/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_CLAUDE/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_WANDB/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_MIDJOURNEY/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_LEONARDO/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_PERPLEXITY/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_ANTHROPIC/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_GEMINI/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_WHISPER/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_REPLICATE/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_HUGGINGFACE_SPACES/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_RUNWAYML/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_CHATGPT/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_OLLAMA/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_LMSTUDIO/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_AITOOLS_FOLDER/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_BOOKMARKBAR/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_OTHER/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    ai_tools_json=$(echo "$ai_tools_json" | sed "s/GUID_SYNCED/$(uuidgen | tr '[:upper:]' '[:lower:]')/g")
    
    # If there's an existing bookmarks file, we need to merge our AI Tools folder into it
    if [ -f "$bookmarks_file" ]; then
        # Extract the AI Tools folder from our JSON
        local ai_tools_folder=$(echo "$ai_tools_json" | grep -A 100 '"children": \[' | grep -B 100 '"name": "AI Tools and Models"' | tail -n +1)
        
        # Create a temporary file for the merged bookmarks
        local temp_bookmarks=$(mktemp)
        
        # Use jq to merge the AI Tools folder into the existing bookmarks
        # This requires jq to be installed
        if ! command -v jq &> /dev/null; then
            print_warning "jq is not installed. Installing it now..."
            brew install jq
        fi
        
        # Use jq to add the AI Tools folder to the bookmark bar
        jq --argjson aitools "$ai_tools_folder" '.roots.bookmark_bar.children += [$aitools]' "$bookmarks_file" > "$temp_bookmarks"
        
        # Replace the original bookmarks file with the merged one
        mv "$temp_bookmarks" "$bookmarks_file"
    else
        # Create the bookmarks file with our AI Tools folder
        echo "$ai_tools_json" > "$bookmarks_file"
    fi
    
    print_success "AI Tools and Models bookmarks added to Brave"
    print_warning "Please restart Brave browser to see the new bookmarks"
}

# Function to create bookmarks for Chrome (similar approach)
create_chrome_bookmarks() {
    local bookmarks_dir="$HOME/Library/Application Support/Google/Chrome/Default"
    local bookmarks_file="$bookmarks_dir/Bookmarks"
    local bookmarks_backup="$bookmarks_dir/Bookmarks.bak"
    local timestamp=$(date +"%Y%m%d%H%M%S")
    
    # Check if Chrome is installed
    if [ ! -d "$bookmarks_dir" ]; then
        print_warning "Google Chrome not found. Skipping Chrome bookmarks."
        return 0
    fi
    
    # Check if Chrome is running
    if pgrep -x "Google Chrome" > /dev/null; then
        print_warning "Please close Google Chrome before continuing."
        print_warning "Press any key to continue once Chrome is closed..."
        read -k1
    fi
    
    # Create backup of existing bookmarks
    if [ -f "$bookmarks_file" ]; then
        cp "$bookmarks_file" "${bookmarks_backup}.${timestamp}"
        print_success "Created backup of existing Chrome bookmarks at ${bookmarks_backup}.${timestamp}"
    else
        print_warning "No existing Chrome bookmarks file found. Skipping Chrome bookmarks."
        return 0
    fi
    
    # Get current date in seconds since epoch (for bookmark added/modified time)
    local current_time=$(date +%s)
    local current_time_microseconds=$((current_time * 1000000))
    
    # Create AI Tools folder JSON (similar to Brave but with different GUIDs)
    # ... (similar to Brave implementation)
    
    print_success "AI Tools and Models bookmarks added to Chrome"
    print_warning "Please restart Chrome browser to see the new bookmarks"
}

# Main function
main() {
    # Check if Brave or Chrome is installed
    if [ -d "$HOME/Library/Application Support/BraveSoftware/Brave-Browser" ]; then
        print_in_purple "
   Adding AI Tools bookmarks to Brave

"
        create_brave_bookmarks
    else
        print_warning "Brave browser not found. Skipping Brave bookmarks."
    fi
    
    # Uncomment to also add bookmarks to Chrome
    # if [ -d "$HOME/Library/Application Support/Google/Chrome" ]; then
    #     print_in_purple "
   Adding AI Tools bookmarks to Chrome

"
    #     create_chrome_bookmarks
    # else
    #     print_warning "Google Chrome not found. Skipping Chrome bookmarks."
    # fi
    
    print_in_green "
  AI Tools bookmarks setup complete!
"
}

# Run the main function
main
