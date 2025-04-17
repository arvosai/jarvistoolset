#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   AI Desktop Applications and Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Local LLM Platforms
print_in_purple "
   Local LLM Platforms

"

# Ollama - Run LLMs locally
brew_cask_install "ollama" "Installing Ollama" false

# OllamaC - Alternative Ollama client
brew_cask_install "ollamac" "Installing OllamaC" true

# NotesOllama - Notes app with Ollama integration
brew_cask_install "notesollama" "Installing NotesOllama" true

# LM Studio - Run and test LLMs locally
brew_cask_install "lm-studio" "Installing LM Studio" true

# AI Chat Clients
print_in_purple "
   AI Chat Clients

"

# ChatGPT - Official OpenAI desktop client
brew_cask_install "chatgpt" "Installing ChatGPT Desktop" true

# Cursor - AI-powered code editor
brew_cask_install "cursor" "Installing Cursor AI Code Editor" true

brew_cask_install "windsurf" "Installing Windsurf AI Code Editor" true

brew_cask_install "bito" "Installing Bito AI Assistant" true



# AI Image Tools
# Many of these tools don't have official casks, using what's available
brew_cask_install "diffusionbee" "Installing DiffusionBee" true

# Mochi Diffusion - MPS-accelerated Stable Diffusion
brew_cask_install "mochi-diffusion" "Installing Mochi Diffusion" true

# Topaz Photo AI - AI photo enhancement
brew_cask_install "topaz-photo-ai" "Installing Topaz Photo AI" true

# Topaz Video AI - AI video enhancement
brew_cask_install "topaz-video-ai" "Installing Topaz Video AI" true

# Topaz Gigapixel AI - AI image upscaling
brew_cask_install "topaz-gigapixel-ai" "Installing Topaz Gigapixel AI" true

# Topaz Sharpen AI - AI image sharpening
brew_cask_install "topaz-sharpen-ai" "Installing Topaz Sharpen AI" true

# Topaz Denoise AI - AI noise reduction
brew_cask_install "topaz-denoise-ai" "Installing Topaz Denoise AI" true

# AI Video Tools
print_in_purple "
   AI Video Tools

"

# Runway - AI video editing
brew_cask_install "runway" "Installing Runway" true

brew_cask_install "d-id" "Installing D-ID Studio" true

brew_cask_install "synthesia" "Installing Synthesia" true

# AI Writing and Productivity
print_in_purple "
   AI Writing and Productivity

"

# Notion - Note-taking with AI features
brew_cask_install "notion" "Installing Notion" true

# Grammarly - AI writing assistant
brew_cask_install "grammarly" "Installing Grammarly" true

# Raindrop.io - AI-enhanced bookmarking
brew_cask_install "raindropio" "Installing Raindrop.io" true

# ProWritingAid - AI writing improvement
brew_cask_install "prowritingaid" "Installing ProWritingAid" true

# AI Development Environments
print_in_purple "
   AI Development Environments

"

# Visual Studio Code - Code editor with AI extensions
brew_cask_install "visual-studio-code" "Installing VS Code" true

# JupyterLab - Web-based interactive development
brew_cask_install "jupyterlab" "Installing JupyterLab" true

# Jupyter Notebook Viewer
brew_cask_install "jupyter-notebook-viewer" "Installing Jupyter Notebook Viewer" true

# Anaconda - Python distribution for data science
brew_cask_install "anaconda" "Installing Anaconda" true

# PyCharm CE - Python IDE with AI features
brew_cask_install "pycharm-ce" "Installing PyCharm Community Edition" true

# PyCharm with Anaconda plugin
brew_cask_install "pycharm-ce-with-anaconda-plugin" "Installing PyCharm CE with Anaconda" true

# JetBrains Toolbox - Manage JetBrains IDEs
brew_cask_install "jetbrains-toolbox" "Installing JetBrains Toolbox" true

# AI Research Tools
print_in_purple "
   AI Research Tools

"

# Zotero - Research paper management
brew_cask_install "zotero" "Installing Zotero" true

# Mendeley Reference Manager
brew_cask_install "mendeley-reference-manager" "Installing Mendeley" true

# AI for Generative Art
print_in_purple "
   AI Generative Art Tools

"

# ChaiNNer - Visual AI image processing
brew_cask_install "chainner" "Installing ChaiNNer" true

# AI Utilities
print_in_purple "
   AI Utilities

"

# Geekbench AI - AI benchmark
brew_cask_install "geekbench-ai" "Installing Geekbench AI" true

# MacAI - AI assistant for macOS
brew_cask_install "macai" "Installing MacAI" true

# BoltAI - AI productivity assistant
brew_cask_install "boltai" "Installing BoltAI" true

# BackyardAI - AI assistant
brew_cask_install "backyard-ai" "Installing BackyardAI" true

# Print a message about other tools that need to be installed manually
print_in_purple "
   Additional AI Tools (Manual Installation)

"

echo "Some AI tools need to be installed manually from their websites:"
echo "1. ElevenLabs - https://elevenlabs.io/download"
echo "2. Hugging Face Tools - https://huggingface.co/docs/hub/en/repositories-getting-started"
echo "3. Stable Diffusion WebUI - https://github.com/AUTOMATIC1111/stable-diffusion-webui"
echo "4. ComfyUI - https://github.com/comfyanonymous/ComfyUI"
echo "5. Claude Desktop - Use the web version at https://claude.ai"
echo "6. Weights & Biases - https://wandb.ai/site"
echo "7. Midjourney - Use the web version at https://www.midjourney.com"
echo "8. Leonardo.AI - Use the web version at https://leonardo.ai"
echo "9. Perplexity AI - Use the web version at https://www.perplexity.ai"
echo "10. Anthropic Claude - Use the web version at https://claude.ai"
echo "11. Gemini - Use the web version at https://gemini.google.com"
echo "12. Whisper Studio - https://github.com/saharmor/whisper-playground"
echo "13. Replicate - Use the web version at https://replicate.com"
echo "14. Hugging Face Spaces - Use the web version at https://huggingface.co/spaces"
echo "15. RunwayML - Use the web version at https://runwayml.com"

print_in_green "
  AI Desktop Tools installation complete!
"
