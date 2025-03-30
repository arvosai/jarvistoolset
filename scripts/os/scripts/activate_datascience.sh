#!/bin/bash
# Activate the Data Science environment

# Ensure pyenv is available
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    
    # Activate the datascience environment
    pyenv activate datascience
    
    echo "Data Science environment activated!"
    echo "This environment includes: Jupyter, Pandas, NumPy, Matplotlib, TensorFlow, PyTorch, etc."
else
    echo "Error: pyenv is not installed or not in PATH"
    exit 1
fi
