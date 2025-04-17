#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Cerebras AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Cerebras
execute "pip3 install cerebras-sdk" \
    "Installing Cerebras SDK"

execute "pip3 install cerebras-client" \
    "Installing Cerebras Client"

execute "pip3 install cerebras-api" \
    "Installing Cerebras API"

# Cerebras Development
execute "pip3 install cerebras-tools" \
    "Installing Cerebras Tools"

execute "pip3 install cerebras-cli" \
    "Installing Cerebras CLI"

execute "pip3 install cerebras-dev" \
    "Installing Cerebras Development Tools"

# Cerebras Models
execute "pip3 install cerebras-gpt" \
    "Installing Cerebras GPT"

execute "pip3 install cerebras-bert" \
    "Installing Cerebras BERT"

execute "pip3 install cerebras-mt" \
    "Installing Cerebras Machine Translation"

# Cerebras Hardware
execute "pip3 install cerebras-wafer" \
    "Installing Cerebras Wafer Tools"

execute "pip3 install cerebras-compiler" \
    "Installing Cerebras Compiler"

execute "pip3 install cerebras-runtime" \
    "Installing Cerebras Runtime"

# Cerebras ML
execute "pip3 install cerebras-pytorch" \
    "Installing Cerebras PyTorch"

execute "pip3 install cerebras-tensorflow" \
    "Installing Cerebras TensorFlow"

execute "pip3 install cerebras-jax" \
    "Installing Cerebras JAX"

# Cerebras Optimization
execute "pip3 install cerebras-optimizer" \
    "Installing Cerebras Optimizer"

execute "pip3 install cerebras-profiler" \
    "Installing Cerebras Profiler"

execute "pip3 install cerebras-tuner" \
    "Installing Cerebras Tuner"

# Cerebras Monitoring
execute "pip3 install cerebras-monitor" \
    "Installing Cerebras Monitor"

execute "pip3 install cerebras-metrics" \
    "Installing Cerebras Metrics"

execute "pip3 install cerebras-logging" \
    "Installing Cerebras Logging"
