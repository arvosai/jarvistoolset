#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Installing Generative AI Productivity Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1. ChatGPT Desktop App
brew_install "ChatGPT" "chatgpt" "cask"

# 2. Raycast (AI-enhanced launcher)
brew_install "Raycast" "raycast" "cask"

# 3. Notion (with AI capabilities)
brew_install "Notion" "notion" "cask"

# 4. Otter.ai (AI transcription)
brew_install "Otter.ai" "otter" "cask"

# 5. Jasper (AI writing assistant)
brew_install "Jasper AI" "jasper" "cask"

# 6. Midjourney Companion (Desktop tool for Midjourney)
brew_install "Midjourney Companion" "midjourney-companion" "cask"

# 7. Mem (AI-powered note-taking)
brew_install "Mem" "mem" "cask"

# 8. Grammarly (AI writing assistant)
brew_install "Grammarly" "grammarly" "cask"

# 9. Firefly (Adobe's generative AI tool)
brew_install "Adobe Firefly" "adobe-creative-cloud" "cask"

# 10. Runway (Video generation and editing)
brew_install "Runway" "runway" "cask"

# Install CLI tools via npm/pip that aren't available via Homebrew

# GitHub Copilot CLI
if cmd_exists "npm"; then
    execute "npm install -g @githubnext/github-copilot-cli" \
        "Installing GitHub Copilot CLI"
else
    print_error "npm is not installed, skipping GitHub Copilot CLI"
fi

# Whisper CLI (OpenAI's speech recognition)
if cmd_exists "pip3"; then
    execute "pip3 install -U openai-whisper" \
        "Installing OpenAI Whisper CLI"
else
    print_error "pip3 is not installed, skipping OpenAI Whisper CLI"
fi

print_in_green "
   Generative AI Productivity Tools installation complete!
"
