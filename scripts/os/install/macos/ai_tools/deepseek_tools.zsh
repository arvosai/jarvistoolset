#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   DeepSeek AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core DeepSeek
execute "pip3 install deepseek-sdk" \
    "Installing DeepSeek SDK"

execute "pip3 install deepseek-client" \
    "Installing DeepSeek Client"

execute "pip3 install deepseek-api" \
    "Installing DeepSeek API"

# DeepSeek Code
execute "pip3 install deepseek-coder" \
    "Installing DeepSeek Coder"

execute "pip3 install deepseek-code-client" \
    "Installing DeepSeek Code Client"

execute "pip3 install deepseek-code-tools" \
    "Installing DeepSeek Code Tools"

# DeepSeek Vision
execute "pip3 install deepseek-vision" \
    "Installing DeepSeek Vision"

execute "pip3 install deepseek-vl" \
    "Installing DeepSeek Vision-Language"

execute "pip3 install deepseek-image" \
    "Installing DeepSeek Image"

# DeepSeek Language
execute "pip3 install deepseek-llm" \
    "Installing DeepSeek LLM"

execute "pip3 install deepseek-mpc" \
    "Installing DeepSeek MPC"

execute "pip3 install deepseek-nlp" \
    "Installing DeepSeek NLP"

# DeepSeek Development
execute "pip3 install deepseek-tools" \
    "Installing DeepSeek Tools"

execute "pip3 install deepseek-cli" \
    "Installing DeepSeek CLI"

execute "pip3 install deepseek-dev" \
    "Installing DeepSeek Development"

# DeepSeek Models
execute "pip3 install deepseek-math" \
    "Installing DeepSeek Math"

execute "pip3 install deepseek-science" \
    "Installing DeepSeek Science"

execute "pip3 install deepseek-research" \
    "Installing DeepSeek Research"

# DeepSeek Integration
execute "pip3 install deepseek-vscode" \
    "Installing DeepSeek VSCode"

execute "pip3 install deepseek-jupyter" \
    "Installing DeepSeek Jupyter"

execute "pip3 install deepseek-ide" \
    "Installing DeepSeek IDE"

# DeepSeek Monitoring
execute "pip3 install deepseek-monitor" \
    "Installing DeepSeek Monitor"

execute "pip3 install deepseek-metrics" \
    "Installing DeepSeek Metrics"

execute "pip3 install deepseek-logging" \
    "Installing DeepSeek Logging"
