#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh"


# Add trap to handle broken pipe errors
trap '' PIPE

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a banner for this installation script
create_install_banner "$0"

# Install Python via Homebrew
brew_install "Python" "python"
brew_install "Python@3.11" "python@3.11"

# Install pyenv for Python version management
brew_install "pyenv" "pyenv"
brew_install "pyenv-virtualenv" "pyenv-virtualenv"

# Create modular configuration file for Python
create_python_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/python.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Python configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Python configuration for zsh
# This file contains all Python-related configurations
#

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
fi

# Python aliases
alias py="python"
alias py3="python3"
alias pip-upgrade="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U"
alias pip3-upgrade="pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U"

# Virtual environment configuration
if [ -d "$VIRTUAL_ENV" ]; then
  export PATH="$VIRTUAL_ENV/bin:$PATH"
fi
EOL
    
    print_result $? "Created Python configuration file"
}

# Install Python versions
print_in_purple "
   Installing Python Versions

"

# Install Python 3.11 with specific patch version
pyenv_install "3.11.8" "false"
if [ $? -ne 0 ]; then
    print_in_red "Failed to install Python 3.11.8"
fi

# Install Python 3.12 with specific patch version
pyenv_install "3.12.2" "true"
if [ $? -ne 0 ]; then
    print_in_red "Failed to install Python 3.12.2"
fi

# Set Python 3.12 as global
pyenv global 3.12.2
print_result $? "Setting Python 3.12.2 as global"

# Install Poetry for dependency management
poetry_install

# Install pipx for isolated application installation
brew_install "pipx" "pipx"
run_command "pipx ensurepath" "pipx path setup"

# Install global development tools
print_in_purple "
   Installing Development Tools

"

# Package Management
pipx_install "pip-tools" "pip-tools"
pipx_install "Poetry" "poetry"

# Development Tools
pipx_install "Black" "black"
pipx_install "isort" "isort"
pipx_install "Pylint" "pylint"
pipx_install "MyPy" "mypy"
pipx_install "Flake8" "flake8"
pipx_install "Bandit" "bandit"
pipx_install "Pyright" "pyright"

# Testing Tools
pipx_install "Pytest" "pytest"
pipx_install "Coverage" "coverage"
pipx_install "Tox" "tox"
pipx_install "Hypothesis" "hypothesis"

# Documentation Tools
pipx_install "Sphinx" "sphinx"
pipx_install "MkDocs" "mkdocs"
pipx_install "pdoc" "pdoc"

# Web Development
pipx_install "Django" "django"
pipx_install "Flask" "flask"
pipx_install "FastAPI" "fastapi"
pipx_install "Streamlit" "streamlit"
pipx_install "Dash" "dash"

# DevOps Tools
pipx_install "Ansible" "ansible"
pipx_install "Fabric" "fabric"

# Database Tools
pipx_install "Alembic" "alembic"

# Utility Tools
pipx_install "Typer" "typer"
pipx_install "Scrapy" "scrapy"

# Create modular configuration
create_python_config

print_in_green "
  Python development environment setup complete!
"
