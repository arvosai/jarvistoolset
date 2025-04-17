#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Oracle AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Oracle AI
execute "pip3 install oci-ai" \
    "Installing Oracle Cloud AI"

execute "pip3 install oci-ai-client" \
    "Installing Oracle AI Client"

execute "pip3 install oci-ai-sdk" \
    "Installing Oracle AI SDK"

# Oracle Language AI
execute "pip3 install oci-ai-language" \
    "Installing Oracle Language AI"

execute "pip3 install oci-ai-translation" \
    "Installing Oracle Translation AI"

execute "pip3 install oci-ai-speech" \
    "Installing Oracle Speech AI"

# Oracle Vision AI
execute "pip3 install oci-ai-vision" \
    "Installing Oracle Vision AI"

execute "pip3 install oci-ai-anomaly" \
    "Installing Oracle Anomaly Detection"

execute "pip3 install oci-ai-document" \
    "Installing Oracle Document AI"

# Oracle Data Science
execute "pip3 install oci-datascience" \
    "Installing Oracle Data Science"

execute "pip3 install oci-datascience-model" \
    "Installing Oracle Data Science Model"

execute "pip3 install oci-datascience-runtime" \
    "Installing Oracle Data Science Runtime"

# Oracle ML
execute "pip3 install oci-ai-forecasting" \
    "Installing Oracle Forecasting"

execute "pip3 install oci-ai-recommendation" \
    "Installing Oracle Recommendation"

execute "pip3 install oci-ai-classification" \
    "Installing Oracle Classification"

# Oracle Development
execute "pip3 install oci-cli" \
    "Installing Oracle CLI"

execute "pip3 install oci-sdk" \
    "Installing Oracle SDK"

execute "pip3 install oci-tools" \
    "Installing Oracle Tools"

# Oracle Integration
execute "pip3 install oci-ai-integration" \
    "Installing Oracle AI Integration"

execute "pip3 install oci-ai-workflow" \
    "Installing Oracle AI Workflow"

execute "pip3 install oci-ai-pipeline" \
    "Installing Oracle AI Pipeline"

# Oracle Monitoring
execute "pip3 install oci-ai-monitoring" \
    "Installing Oracle AI Monitoring"

execute "pip3 install oci-ai-metrics" \
    "Installing Oracle AI Metrics"

execute "pip3 install oci-ai-logging" \
    "Installing Oracle AI Logging"
