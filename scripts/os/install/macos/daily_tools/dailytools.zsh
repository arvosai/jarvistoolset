#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Daily Tools

"

# System Utilities
print_in_purple "   System Utilities

"

if brew list --cask | grep -q "appcleaner"; then
    print_success "AppCleaner (already installed)"
else
    brew install --cask appcleaner &> /dev/null
    print_result $? "AppCleaner"
fi

if brew list --cask | grep -q "rectangle"; then
    print_success "Rectangle (already installed)"
else
    brew install --cask rectangle &> /dev/null
    print_result $? "Rectangle"
fi

if brew list --cask | grep -q "spectacle"; then
    print_success "Spectacle (already installed)"
else
    brew install --cask spectacle &> /dev/null
    print_result $? "Spectacle"
fi

# Cloud Storage
print_in_purple "
   Cloud Storage

"

if brew list --cask | grep -q "dropbox"; then
    print_success "Dropbox (already installed)"
else
    brew install --cask dropbox &> /dev/null
    print_result $? "Dropbox"
fi

if brew list --cask | grep -q "google-drive"; then
    print_success "Google Drive (already installed)"
else
    brew install --cask google-drive &> /dev/null
    print_result $? "Google Drive"
fi

# Security Tools
print_in_purple "
   Security Tools

"

if brew list --cask | grep -q "veracrypt"; then
    print_success "VeraCrypt (already installed)"
else
    brew install --cask veracrypt &> /dev/null
    print_result $? "VeraCrypt"
fi

if brew list --cask | grep -q "1password"; then
    print_success "1Password (already installed)"
else
    brew install --cask 1password &> /dev/null
    print_result $? "1Password"
fi

# Development Tools
print_in_purple "
   Development Tools

"

if brew list --cask | grep -q "powershell"; then
    print_success "PowerShell (already installed)"
else
    brew install --cask powershell &> /dev/null
    print_result $? "PowerShell"
fi

if brew list --cask | grep -q "iterm2"; then
    print_success "iTerm2 (already installed)"
else
    brew install --cask iterm2 &> /dev/null
    print_result $? "iTerm2"
fi

# Media Tools
print_in_purple "
   Media Tools

"

if brew list --cask | grep -q "vlc"; then
    print_success "VLC (already installed)"
else
    brew install --cask vlc &> /dev/null
    print_result $? "VLC"
fi

if brew list --cask | grep -q "smart-converter"; then
    print_success "Smart Converter (already installed)"
else
    brew install --cask smart-converter &> /dev/null
    print_result $? "Smart Converter"
fi

# Communication
print_in_purple "
   Communication

"

if brew list --cask | grep -q "slack"; then
    print_success "Slack (already installed)"
else
    brew install --cask slack &> /dev/null
    print_result $? "Slack"
fi

if brew list --cask | grep -q "zoom"; then
    print_success "Zoom (already installed)"
else
    brew install --cask zoom &> /dev/null
    print_result $? "Zoom"
fi

# Productivity Tools
print_in_purple "
   Productivity Tools

"

if brew list --cask | grep -q "grammarly"; then
    print_success "Grammarly (already installed)"
else
    brew install --cask grammarly &> /dev/null
    print_result $? "Grammarly"
fi

if brew list --cask | grep -q "parallels"; then
    print_success "Parallels Desktop (already installed)"
else
    brew install --cask parallels &> /dev/null
    print_result $? "Parallels Desktop"
fi

if brew list --cask | grep -q "goodsync"; then
    print_success "GoodSync (already installed)"
else
    brew install --cask goodsync &> /dev/null
    print_result $? "GoodSync"
fi

if brew list --cask | grep -q "snagit"; then
    print_success "SnagIt (already installed)"
else
    brew install --cask snagit &> /dev/null
    print_result $? "SnagIt"
fi

if brew list --cask | grep -q "teamviewer"; then
    print_success "TeamViewer (already installed)"
else
    brew install --cask teamviewer &> /dev/null
    print_result $? "TeamViewer"
fi

if brew list --cask | grep -q "anydesk"; then
    print_success "AnyDesk (already installed)"
else
    brew install --cask anydesk &> /dev/null
    print_result $? "AnyDesk"
fi

if brew list --cask | grep -q "notion"; then
    print_success "Notion (already installed)"
else
    brew install --cask notion &> /dev/null
    print_result $? "Notion"
fi

if brew list --cask | grep -q "microsoft-teams"; then
    print_success "Microsoft Teams (already installed)"
else
    brew install --cask microsoft-teams &> /dev/null
    print_result $? "Microsoft Teams"
fi

print_in_green "
  Daily tools setup complete!
"
