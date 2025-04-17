#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Git Tools

"

# Core Git Tools
if brew list | grep -q "git"; then
    print_success "Git (already installed)"
else
    brew install git &> /dev/null
    print_result $? "Git"
fi

if brew list | grep -q "git-lfs"; then
    print_success "Git LFS (already installed)"
else
    brew install git-lfs &> /dev/null
    print_result $? "Git LFS"
fi

if brew list | grep -q "gh"; then
    print_success "GitHub CLI (already installed)"
else
    brew install gh &> /dev/null
    print_result $? "GitHub CLI"
fi

# Git GUI Clients
if brew list --cask | grep -q "sourcetree"; then
    print_success "Sourcetree (already installed)"
else
    brew install --cask sourcetree &> /dev/null
    print_result $? "Sourcetree"
fi

if brew list --cask | grep -q "gitkraken"; then
    print_success "GitKraken (already installed)"
else
    brew install --cask gitkraken &> /dev/null
    print_result $? "GitKraken"
fi

if brew list --cask | grep -q "fork"; then
    print_success "Fork (already installed)"
else
    brew install --cask fork &> /dev/null
    print_result $? "Fork"
fi

# Git Utilities
if brew list | grep -q "git-flow"; then
    print_success "Git Flow (already installed)"
else
    brew install git-flow &> /dev/null
    print_result $? "Git Flow"
fi

if brew list | grep -q "git-delta"; then
    print_success "Git Delta (already installed)"
else
    brew install git-delta &> /dev/null
    print_result $? "Git Delta"
fi

if brew list | grep -q "git-filter-repo"; then
    print_success "Git Filter Repo (already installed)"
else
    brew install git-filter-repo &> /dev/null
    print_result $? "Git Filter Repo"
fi

if brew list | grep -q "git-gui"; then
    print_success "Git GUI (already installed)"
else
    brew install git-gui &> /dev/null
    print_result $? "Git GUI"
fi

# Code Review Tools
if brew list | grep -q "diff-so-fancy"; then
    print_success "Diff So Fancy (already installed)"
else
    brew install diff-so-fancy &> /dev/null
    print_result $? "Diff So Fancy"
fi

if brew list | grep -q "git-interactive-rebase-tool"; then
    print_success "Git Interactive Rebase Tool (already installed)"
else
    brew install git-interactive-rebase-tool &> /dev/null
    print_result $? "Git Interactive Rebase Tool"
fi

# Git Hooks and Automation
if brew list | grep -q "pre-commit"; then
    print_success "Pre-commit (already installed)"
else
    brew install pre-commit &> /dev/null
    print_result $? "Pre-commit"
fi

if command -v npm &> /dev/null && npm list -g | grep -q "husky"; then
    print_success "Husky (already installed)"
else
    if command -v npm &> /dev/null; then
        npm install -g husky &> /dev/null
        print_result $? "Husky"
    else
        print_warning "npm not found. Skipping Husky installation."
    fi
fi

# Git Security
if brew list | grep -q "git-secrets"; then
    print_success "Git Secrets (already installed)"
else
    brew install git-secrets &> /dev/null
    print_result $? "Git Secrets"
fi

if brew list | grep -q "git-crypt"; then
    print_success "Git Crypt (already installed)"
else
    brew install git-crypt &> /dev/null
    print_result $? "Git Crypt"
fi

# Git Configuration
print_in_purple "
   Git Configuration

"

# Configure Git credential helper
if [[ "$(git config --global credential.helper)" == "osxkeychain" ]]; then
    print_success "Git credential helper already configured"
else
    git config --global credential.helper osxkeychain &> /dev/null
    print_result $? "Configure Git credential helper"
fi

# Configure Git to use SSH for GitHub
if grep -q "Host github.com" ~/.ssh/config 2>/dev/null; then
    print_success "Git SSH for GitHub already configured"
else
    if [[ ! -d ~/.ssh ]]; then
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
    fi
    
    if [[ ! -f ~/.ssh/config ]]; then
        touch ~/.ssh/config
        chmod 600 ~/.ssh/config
    fi
    
    cat >> ~/.ssh/config << EOF
# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
EOF
    print_result $? "Configure Git to use SSH for GitHub"
fi

print_in_green "
  Git tools setup complete!
"
