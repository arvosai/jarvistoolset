#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Data Science Environment

"

# Create a dedicated virtual environment for data science packages
DATASCIENCE_ENV="datascience"
pyenv virtualenv 3.12.2 $DATASCIENCE_ENV 2>/dev/null || true
print_result $? "Creating Data Science virtual environment"

# Function to install packages in the data science environment
pip_install_in_env() {
    local -r PACKAGE_READABLE_NAME="$1"
    local -r PACKAGE="$2"
    
    PYENV_VERSION=$DATASCIENCE_ENV pip install $PACKAGE -U &>/dev/null
    print_result $? "$PACKAGE_READABLE_NAME"
}

# Data Science packages
pip_install_in_env "Jupyter" "jupyter"
pip_install_in_env "Pandas" "pandas"
pip_install_in_env "NumPy" "numpy"
pip_install_in_env "Matplotlib" "matplotlib"
pip_install_in_env "Seaborn" "seaborn"
pip_install_in_env "SciPy" "scipy"
pip_install_in_env "Scikit-learn" "scikit-learn"

# Machine Learning packages
pip_install_in_env "TensorFlow" "tensorflow"
# Fix PyTorch installation for macOS - use the official installation command
print_in_yellow "Installing PyTorch for macOS...
"
if [[ "$(uname -m)" == "arm64" ]]; then
    # For Apple Silicon (M1/M2/M3)
    PYENV_VERSION=$DATASCIENCE_ENV pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
    print_result $? "PyTorch (Apple Silicon)"
else
    # For Intel Macs
    PYENV_VERSION=$DATASCIENCE_ENV pip install torch torchvision torchaudio
    print_result $? "PyTorch (Intel)"
fi
pip_install_in_env "Keras" "keras"
pip_install_in_env "XGBoost" "xgboost"
pip_install_in_env "LightGBM" "lightgbm"

# Create activation script for the data science environment
DIRECTORY="${SCRIPT_DIR}/../../.."
ACTIVATE_SCRIPT="${DIRECTORY}/scripts/activate_datascience.sh"
mkdir -p "$(dirname "$ACTIVATE_SCRIPT")"

cat > "$ACTIVATE_SCRIPT" << EOL
#!/bin/bash
# Activate the Data Science environment

# Ensure pyenv is available
if command -v pyenv 1>/dev/null 2>&1; then
    eval "\$(pyenv init -)"
    eval "\$(pyenv virtualenv-init -)"
    
    # Activate the datascience environment
    pyenv activate datascience
    
    echo "Data Science environment activated!"
    echo "This environment includes: Jupyter, Pandas, NumPy, Matplotlib, TensorFlow, PyTorch, etc."
else
    echo "Error: pyenv is not installed or not in PATH"
    exit 1
fi
EOL

chmod +x "$ACTIVATE_SCRIPT"
print_result $? "Creating Data Science activation script"

print_in_yellow "
  To activate the Data Science environment, run:
"
print_in_yellow "  source ${DIRECTORY}/scripts/activate_datascience.sh
"
