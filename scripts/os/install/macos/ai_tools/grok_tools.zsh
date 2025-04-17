#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Grok AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Grok
execute "pip3 install grok-sdk" \
    "Installing Grok SDK"

execute "pip3 install grok-client" \
    "Installing Grok Client"

execute "pip3 install grok-api" \
    "Installing Grok API"

# Grok Development
execute "pip3 install grok-tools" \
    "Installing Grok Tools"

execute "pip3 install grok-cli" \
    "Installing Grok CLI"

execute "pip3 install grok-dev" \
    "Installing Grok Development Tools"

# Grok Models
execute "pip3 install grok-model" \
    "Installing Grok Model"

execute "pip3 install grok-inference" \
    "Installing Grok Inference"

execute "pip3 install grok-training" \
    "Installing Grok Training"

# Grok Integration
execute "pip3 install grok-x" \
    "Installing Grok X Integration"

execute "pip3 install grok-twitter" \
    "Installing Grok Twitter"

execute "pip3 install grok-social" \
    "Installing Grok Social"

# Grok Analysis
execute "pip3 install grok-analytics" \
    "Installing Grok Analytics"

execute "pip3 install grok-metrics" \
    "Installing Grok Metrics"

execute "pip3 install grok-monitoring" \
    "Installing Grok Monitoring"

# Grok Security
execute "pip3 install grok-auth" \
    "Installing Grok Auth"

execute "pip3 install grok-security" \
    "Installing Grok Security"

execute "pip3 install grok-privacy" \
    "Installing Grok Privacy"
