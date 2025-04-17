#!/bin/zsh
#
# Install and configure Oh My Zsh
#
# This script installs Oh My Zsh and configures it with recommended settings
# It also installs popular plugins and themes
#

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh" 2>/dev/null || true  # Source local utils if available

# Check if Oh My Zsh is already installed
check_oh_my_zsh_installed() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        return 0
    else
        return 1
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    print_info "Installing Oh My Zsh..."
    
    # Backup existing .zshrc if it exists
    if [[ -f "$HOME/.zshrc" ]]; then
        print_info "Backing up existing .zshrc to .zshrc.backup"
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
    
    # Install Oh My Zsh silently
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
    
    print_result $? "Oh My Zsh"
}

# Install custom plugins
install_custom_plugins() {
    print_info "Installing custom Oh My Zsh plugins..."
    
    # Create custom plugins directory if it doesn't exist
    mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
    
    # Install zsh-syntax-highlighting
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" --quiet
        print_result $? "zsh-syntax-highlighting plugin"
    fi
    
    # Install zsh-autosuggestions
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" --quiet
        print_result $? "zsh-autosuggestions plugin"
    fi
    
    # Install zsh-completions
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]]; then
        git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" --quiet
        print_result $? "zsh-completions plugin"
    fi
}

# Install custom themes
install_custom_themes() {
    print_info "Installing custom Oh My Zsh themes..."
    
    # Create custom themes directory if it doesn't exist
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    
    # Install Powerlevel10k theme
    if [[ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" --quiet
        print_result $? "Powerlevel10k theme"
    fi
    
    # Create arvosai theme if it doesn't exist
    if [[ ! -f "$HOME/.oh-my-zsh/custom/themes/arvosai.zsh-theme" ]]; then
        cat > "$HOME/.oh-my-zsh/custom/themes/arvosai.zsh-theme" << 'EOL'
# vim:ft=zsh ts=2 sw=2 sts=2
#
# ARVOS.AI's Theme - https://gist.github.com/arvosai/3a76d0c980bf0e6ef9a1014b9ed281bc

# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='INIT'

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR="%{%F{green} %}%{%f "
  
  fortune | cowsay -t $1 -f eyes

  echo " "
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg


  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'INIT' ]]; then 
    echo -n $SEGMENT_SEPARATOR
  else
    echo -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  CURRENT_FG=$2

  [[ -n $3 ]] && echo -n "%{$fg%}$3"
  echo -n "%{$bg%}%{$fg%}"
}


# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo ''
  echo -n "%{%f%}%{%b%}%b]"
  CURRENT_BG=''
}


# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local -a symbols

  symbols="%{%F{white}%}"

  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%} ✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%} ⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%} ⚙"

  [[ -n "$symbols" ]] && prompt_segment NONE default "$symbols"
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
#    prompt_segment black magenta "%(!.%{%F{red}%}.)%n in %m"
    prompt_segment NONE magenta "%(!.%{%F{red}%}%n.)%n %{%F{yellow}%}in %{%F{green}%}%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$''         # 
  }
  local ref dirty mode repo_path

   if [[ "$(command git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    repo_path=$(command git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref="◈ $(command git describe --exact-match --tags HEAD 2> /dev/null)" || \
    ref="➦ $(command git rev-parse --short HEAD 2> /dev/null)"
    
    if [[ -n $dirty ]]; then
      prompt_segment NONE yellow
    else
      prompt_segment NONE green
    fi

    local ahead behind
    ahead=$(command git log --oneline @{upstream}.. 2>/dev/null)
    behind=$(command git log --oneline ..@{upstream} 2>/dev/null)
    if [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'⇅'
    elif [[ -n "$ahead" ]]; then
      PL_BRANCH_CHAR=$'↱'
    elif [[ -n "$behind" ]]; then
      PL_BRANCH_CHAR=$'↰'
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '±'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info

    echo -n "${${ref:gs/%/%%}/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_bzr() {
  (( $+commands[bzr] )) || return

  # Test if bzr repository in directory hierarchy
  local dir="$PWD"
  while [[ ! -d "$dir/.bzr" ]]; do
    [[ "$dir" = "/" ]] && return
    dir="${dir:h}"
  done

  local bzr_status status_mod status_all revision
  if bzr_status=$(command bzr status 2>&1); then
    status_mod=$(echo -n "$bzr_status" | head -n1 | grep "modified" | wc -m)
    status_all=$(echo -n "$bzr_status" | head -n1 | wc -m)
    revision=${$(command bzr log -r-1 --log-format line | cut -d: -f1):gs/%/%%}
    if [[ $status_mod -gt 0 ]] ; then
      prompt_segment yellow black "bzr@$revision ✚"
    else
      if [[ $status_all -gt 0 ]] ; then
        prompt_segment yellow black "bzr@$revision"
      else
        prompt_segment green black "bzr@$revision"
      fi
    fi
  fi
}

prompt_hg() {
  (( $+commands[hg] )) || return
  local rev st branch
  if $(command hg id >/dev/null 2>&1); then
    if $(command hg prompt >/dev/null 2>&1); then
      if [[ $(command hg prompt "{status|unknown}") = "?" ]]; then
        # if files are not added
        prompt_segment white red
        st='±'
      elif [[ -n $(command hg prompt "{status|modified}") ]]; then
        # if any modification
        prompt_segment black yellow
        st='±'
      else
        # if working copy is clean
        prompt_segment black green
      fi
      echo -n ${$(command hg prompt "☿ {rev}@{branch}"):gs/%/%%} $st
    else
      st=""
      rev=$(command hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(command hg id -b 2>/dev/null)
      if command hg st | command grep -q "^\?"; then
        prompt_segment black red
        st='±'
      elif command hg st | command grep -q "^[MA]"; then
        prompt_segment black yellow
        st='±'
      else
        prompt_segment black green
      fi
      echo -n "☿ ${rev:gs/%/%%}@${branch:gs/%/%%}" $st
    fi
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment NONE cyan '%~'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" && -n "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    prompt_segment NONE green "(${VIRTUAL_ENV:t:gs/%/%%})"
  fi
}


#AWS Profile:
# - display current AWS_PROFILE name
# - displays yellow on red if profile name contains 'production' or
#   ends in '-prod'
# - displays black on green otherwise
prompt_aws() {
  [[ -z "$AWS_PROFILE" || "$SHOW_AWS_PROMPT" = false ]] && return
  case "$AWS_PROFILE" in
    *-prod|*production*) prompt_segment red yellow  "AWS: ${AWS_PROFILE:gs/%/%%}" ;;
    *) prompt_segment green black "AWS: ${AWS_PROFILE:gs/%/%%}" ;;
  esac
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_aws
  prompt_context
  prompt_dir
  prompt_git
  prompt_bzr
  prompt_hg
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
EOL
        print_result $? "arvosai theme"
    fi
}

# Configure Oh My Zsh
configure_oh_my_zsh() {
    print_info "Configuring Oh My Zsh..."
    
    # Create a new .zshrc file with our configuration
    cat > "$HOME/.zshrc" << 'EOL'
# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
export ZSH_THEME="arvosai"

# Uncomment to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment to use hyphen-insensitive completion
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment the following line to change how often to auto-update (in days)
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    1password 
    autoenv 
    aws 
    azure 
    branch 
    brew 
    colored-man-pages 
    colorize 
    command-not-found
    conda-env
    copyfile
    copypath
    cp
    dircycle
    direnv
    dirhistory
    docker-compose
    docker
    emoji
    encode64
    flutter
    frontend-search
    gas
    gcloud
    gh
    git-auto-fetch
    git-commit
    git-extras
    git
    gitfast
    github
    gitignore
    golang
    helm
    history-substring-search
    history
    ipfs
    iterm2
    jira
    keychain
    kubectl
    kubectx
    last-working-dir
    macos
    magic-enter
    man
    marked2
    marktext
    minikube
    mongo-atlas
    mongocli
    ng
    node
    npm
    nvm
    pip
    pipenv
    profiles
    pyenv
    python
    qodana
    qrcode
    react-native
    ruby
    rsync
    rust
    safe-paste
    ssh-agent
    sudo
    terraform
    thefuck
    tldr
    urltools
    virtualenv
    vscode
    web-search
    xcode
    yarn
    yum
    z
    zsh-navigation-tools
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
)

source $ZSH/oh-my-zsh.sh

#==============================================================================
# MODULAR CONFIGURATION
#==============================================================================

# Source all modular configuration files
JARVIS_ZSH_CONFIGS="$HOME/.jarvistoolset/zsh_configs"

# Source exports first
if [[ -f "$JARVIS_ZSH_CONFIGS/exports.zsh" ]]; then
  source "$JARVIS_ZSH_CONFIGS/exports.zsh"
fi

# Source all other configuration files
if [[ -d "$JARVIS_ZSH_CONFIGS" ]]; then
  # First source Java configuration to ensure Java is available for other tools
  if [[ -f "$JARVIS_ZSH_CONFIGS/java.zsh" ]]; then
    source "$JARVIS_ZSH_CONFIGS/java.zsh"
  fi
  
  # Then source all other configuration files
  for config_file in "$JARVIS_ZSH_CONFIGS"/*.zsh; do
    # Skip exports.zsh and java.zsh as they're already sourced
    if [[ "$config_file" != "$JARVIS_ZSH_CONFIGS/exports.zsh" && "$config_file" != "$JARVIS_ZSH_CONFIGS/java.zsh" ]]; then
      source "$config_file"
    fi
  done
fi

#==============================================================================
# USER CUSTOMIZATIONS
#==============================================================================

# Add your custom configurations below this line

EOL
    print_result $? "Oh My Zsh configuration"
}

# Main function
main() {
    # Check if script is being run with root privileges
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run with sudo or as root"
        exit 1
    fi
    
    # Check if Oh My Zsh is already installed
    if check_oh_my_zsh_installed; then
        print_success "Oh My Zsh is already installed"
    else
        install_oh_my_zsh
    fi
    
    # Install custom plugins and themes
    install_custom_plugins
    install_custom_themes
    
    # Only configure if the user wants to
    if [[ "$1" == "--configure" ]]; then
        print_info "Configuring Oh My Zsh with default settings"
        configure_oh_my_zsh
        print_success "Oh My Zsh has been configured with default settings"
        print_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
    else
        print_info "Oh My Zsh installation complete"
        print_info "Use --configure flag to overwrite existing .zshrc"
    fi
    
    return 0
}

# Run the script
main "$@"
