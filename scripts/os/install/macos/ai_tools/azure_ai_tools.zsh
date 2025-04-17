#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Azure AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Azure AI
execute "pip3 install azure-ai-ml" \
    "Installing Azure AI ML"

execute "pip3 install azure-cognitiveservices-vision-computervision" \
    "Installing Azure Computer Vision"

execute "pip3 install azure-cognitiveservices-language-textanalytics" \
    "Installing Azure Text Analytics"

# Azure OpenAI
execute "pip3 install azure-openai" \
    "Installing Azure OpenAI"

execute "pip3 install azure-openai-client" \
    "Installing Azure OpenAI Client"

execute "pip3 install azure-openai-embedding" \
    "Installing Azure OpenAI Embedding"

# Azure ML
execute "pip3 install azureml-sdk" \
    "Installing Azure ML SDK"

execute "pip3 install azureml-core" \
    "Installing Azure ML Core"

execute "pip3 install azureml-pipeline" \
    "Installing Azure ML Pipeline"

# Azure Cognitive Services
execute "pip3 install azure-cognitiveservices-speech" \
    "Installing Azure Speech"

execute "pip3 install azure-cognitiveservices-vision-face" \
    "Installing Azure Face"

execute "pip3 install azure-cognitiveservices-vision-customvision" \
    "Installing Azure Custom Vision"

# Azure Bot Service
execute "pip3 install azure-bot" \
    "Installing Azure Bot"

execute "pip3 install azure-bot-client" \
    "Installing Azure Bot Client"

execute "pip3 install azure-bot-schema" \
    "Installing Azure Bot Schema"

# Azure Search
execute "pip3 install azure-search-documents" \
    "Installing Azure Search"

execute "pip3 install azure-search-client" \
    "Installing Azure Search Client"

execute "pip3 install azure-search-nspkg" \
    "Installing Azure Search Package"

# Azure Language
execute "pip3 install azure-ai-language-text" \
    "Installing Azure Language Text"

execute "pip3 install azure-ai-language-conversations" \
    "Installing Azure Language Conversations"

execute "pip3 install azure-ai-language-questionanswering" \
    "Installing Azure QnA"

# Azure Form
execute "pip3 install azure-ai-formrecognizer" \
    "Installing Azure Form Recognizer"

execute "pip3 install azure-ai-metricsadvisor" \
    "Installing Azure Metrics Advisor"

execute "pip3 install azure-ai-anomalydetector" \
    "Installing Azure Anomaly Detector"
