#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Google AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Google AI
execute "pip3 install google-generativeai" \
    "Installing Google Generative AI"

execute "pip3 install google-ai-generativelanguage" \
    "Installing Google Generative Language"

execute "pip3 install google-cloud-aiplatform" \
    "Installing Google AI Platform"

# Google Cloud AI Services
execute "pip3 install google-cloud-vision" \
    "Installing Google Cloud Vision"

execute "pip3 install google-cloud-speech" \
    "Installing Google Cloud Speech"

execute "pip3 install google-cloud-translate" \
    "Installing Google Cloud Translation"

execute "pip3 install google-cloud-language" \
    "Installing Google Cloud Natural Language"

execute "pip3 install google-cloud-videointelligence" \
    "Installing Google Cloud Video Intelligence"

# Google AI Research Tools
execute "pip3 install tensorflow" \
    "Installing TensorFlow"

execute "pip3 install tensorflow-hub" \
    "Installing TensorFlow Hub"

execute "pip3 install tensorflow-text" \
    "Installing TensorFlow Text"

execute "pip3 install tensorflow-datasets" \
    "Installing TensorFlow Datasets"

# Google Vertex AI
execute "pip3 install google-cloud-aiplatform[pipelines]" \
    "Installing Vertex AI Pipelines"

execute "pip3 install google-cloud-aiplatform[tensorboard]" \
    "Installing Vertex AI TensorBoard"

execute "pip3 install google-cloud-aiplatform[feature-store]" \
    "Installing Vertex AI Feature Store"

# Google ML Tools
execute "pip3 install google-cloud-ml-engine" \
    "Installing Google ML Engine"

execute "pip3 install google-cloud-automl" \
    "Installing Google AutoML"

execute "pip3 install google-cloud-notebooks" \
    "Installing Google Cloud Notebooks"

# Google AI Studio
execute "pip3 install google-ai-studio" \
    "Installing Google AI Studio"

execute "pip3 install google-ai-studio-client" \
    "Installing Google AI Studio Client"

# Google Research Tools
execute "pip3 install jax" \
    "Installing JAX"

execute "pip3 install flax" \
    "Installing Flax"

execute "pip3 install trax" \
    "Installing Trax"

# Google AI Ethics Tools
execute "pip3 install tensorflow-model-remediation" \
    "Installing TensorFlow Model Remediation"

execute "pip3 install tensorflow-privacy" \
    "Installing TensorFlow Privacy"

execute "pip3 install tensorflow-model-analysis" \
    "Installing TensorFlow Model Analysis"
