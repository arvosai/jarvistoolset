#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Installing Visual Studio Code

"

# Install Visual Studio Code
if brew_install "Visual Studio Code" "visual-studio-code" "--cask"; then
    print_success "Visual Studio Code installed"
    
    # Install VS Code extensions
    execute "code --install-extension ms-python.python" "Installing Python extension"
    execute "code --install-extension ms-vscode.cpptools" "Installing C/C++ extension"
    execute "code --install-extension dbaeumer.vscode-eslint" "Installing ESLint extension"
    execute "code --install-extension esbenp.prettier-vscode" "Installing Prettier extension"
    execute "code --install-extension ms-azuretools.vscode-docker" "Installing Docker extension"
    execute "code --install-extension github.copilot" "Installing GitHub Copilot extension"
    execute "code --install-extension github.vscode-pull-request-github" "Installing GitHub Pull Requests extension"
    execute "code --install-extension codeium.codeium" "Installing Codeium extension"
fi

print_in_purple "
 >> Visual Studio Code installation completed

"
