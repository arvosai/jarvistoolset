#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   OpenAI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core OpenAI
execute "pip3 install openai" \
    "Installing OpenAI SDK"

execute "pip3 install openai[datalib]" \
    "Installing OpenAI Data Libraries"

execute "pip3 install openai[embeddings]" \
    "Installing OpenAI Embeddings"

execute "pip3 install openai[wandb]" \
    "Installing OpenAI Weights & Biases"

# OpenAI Models
execute "pip3 install tiktoken" \
    "Installing OpenAI Tokenizer"

execute "pip3 install gpt-3" \
    "Installing GPT-3 SDK"

execute "pip3 install gpt-4" \
    "Installing GPT-4 SDK"

execute "pip3 install claude-api" \
    "Installing Claude API"

# OpenAI Audio
execute "pip3 install whisper" \
    "Installing Whisper"

execute "pip3 install whisper-timestamped" \
    "Installing Whisper Timestamped"

execute "pip3 install tts" \
    "Installing TTS"

# OpenAI Vision
execute "pip3 install dall-e" \
    "Installing DALL-E"

execute "pip3 install clip" \
    "Installing CLIP"

execute "pip3 install point-e" \
    "Installing Point-E"

# OpenAI Development
execute "pip3 install guidance" \
    "Installing Guidance"

execute "pip3 install function-calling" \
    "Installing Function Calling"

execute "pip3 install openai-tools" \
    "Installing OpenAI Tools"

# OpenAI Fine-tuning
execute "pip3 install openai-fine-tuning" \
    "Installing OpenAI Fine-tuning"

execute "pip3 install openai-dataset" \
    "Installing OpenAI Dataset"

execute "pip3 install openai-eval" \
    "Installing OpenAI Eval"

# OpenAI Monitoring
execute "pip3 install openai-metrics" \
    "Installing OpenAI Metrics"

execute "pip3 install openai-logging" \
    "Installing OpenAI Logging"

execute "pip3 install openai-monitoring" \
    "Installing OpenAI Monitoring"
