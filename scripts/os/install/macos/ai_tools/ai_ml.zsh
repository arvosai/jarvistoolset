#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
 >> Installing AI and ML Tools

"

# Install TensorFlow
if brew_install "tensorflow" "tensorflow"; then
    print_success "TensorFlow installed"
fi

# Install PyTorch
if brew_install "pytorch" "pytorch"; then
    print_success "PyTorch installed"
fi

# Install Jupyter
if pip_install "jupyter" "Installing Jupyter"; then
    print_success "Jupyter installed"
fi

# Install scikit-learn
if pip_install "scikit-learn" "Installing scikit-learn"; then
    print_success "scikit-learn installed"
fi

# Install pandas
if pip_install "pandas" "Installing pandas"; then
    print_success "pandas installed"
fi

# Install matplotlib
if pip_install "matplotlib" "Installing matplotlib"; then
    print_success "matplotlib installed"
fi

print_in_purple "
 >> AI and ML Tools installation completed

"
