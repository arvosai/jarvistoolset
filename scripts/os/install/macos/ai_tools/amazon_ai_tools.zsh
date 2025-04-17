#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Amazon AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Amazon Bedrock
execute "pip3 install boto3" \
    "Installing AWS SDK"

execute "pip3 install amazon-bedrock-sdk" \
    "Installing Amazon Bedrock SDK"

execute "pip3 install amazon-bedrock-runtime" \
    "Installing Amazon Bedrock Runtime"

execute "pip3 install amazon-bedrock-agent" \
    "Installing Amazon Bedrock Agent"

# Amazon SageMaker
execute "pip3 install sagemaker" \
    "Installing SageMaker"

execute "pip3 install sagemaker-python-sdk" \
    "Installing SageMaker Python SDK"

execute "pip3 install sagemaker-experiments" \
    "Installing SageMaker Experiments"

execute "pip3 install sagemaker-training" \
    "Installing SageMaker Training"

# Amazon AI Services
execute "pip3 install amazon-textract-sdk" \
    "Installing Amazon Textract"

execute "pip3 install amazon-rekognition-sdk" \
    "Installing Amazon Rekognition"

execute "pip3 install amazon-comprehend" \
    "Installing Amazon Comprehend"

execute "pip3 install amazon-transcribe" \
    "Installing Amazon Transcribe"

# Amazon CodeWhisperer
execute "pip3 install aws-codewhisperer" \
    "Installing AWS CodeWhisperer"

execute "pip3 install aws-codewhisperer-cli" \
    "Installing AWS CodeWhisperer CLI"

# Amazon ML Tools
execute "pip3 install amazon-braket-sdk" \
    "Installing Amazon Braket SDK"

execute "pip3 install amazon-neuron-sdk" \
    "Installing Amazon Neuron SDK"

execute "pip3 install amazon-sagemaker-clarify" \
    "Installing SageMaker Clarify"

# Amazon AI Development
execute "pip3 install awscli" \
    "Installing AWS CLI"

execute "pip3 install aws-sam-cli" \
    "Installing AWS SAM CLI"

execute "pip3 install aws-cdk" \
    "Installing AWS CDK"

# Amazon AI Security
execute "pip3 install amazon-verified-permissions" \
    "Installing Amazon Verified Permissions"

execute "pip3 install amazon-fraud-detector" \
    "Installing Amazon Fraud Detector"

execute "pip3 install amazon-guardduty" \
    "Installing Amazon GuardDuty"
