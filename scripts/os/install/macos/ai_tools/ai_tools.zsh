#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   AI Development Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# OpenAI Tools
pip_install "OpenAI Python SDK" "openai"

pip_install "OpenAI Whisper" "whisper"

pip_install "OpenAI Tokenizer" "tiktoken"

pip_install "OpenAI Function Tools" "openai-functions"

pip_install "Guidance for OpenAI" "guidance"

# Anthropic Tools
pip_install "Anthropic SDK" "anthropic"

pip_install "Claude API" "claude-api"

# Google AI Tools
pip_install "Google Generative AI" "google-generativeai"

pip_install "Google AI Platform" "google-cloud-aiplatform"

pip_install "Google Cloud Vision" "google-cloud-vision"

pip_install "Google Cloud Speech" "google-cloud-speech"

pip_install "Google Cloud Translate" "google-cloud-translate"

# AWS AI Services
pip_install "AWS SDK" "boto3"

pip_install "SageMaker SDK" "sagemaker"

pip_install "Amazon Textract" "amazon-textract-textractor"

# Azure AI Tools
pip_install "Azure Computer Vision" "azure-cognitiveservices-vision-computervision"

pip_install "Azure Text Analytics" "azure-cognitiveservices-language-textanalytics"

pip_install "Azure Conversations" "azure-ai-language-conversations"

pip_install "Azure ML" "azure-ai-ml"

# Meta AI Tools
pip_install "PyTorch" "torch"

# Hugging Face Tools
pip_install "Transformers" "transformers"

pip_install "Datasets" "datasets"

pip_install "Diffusers" "diffusers"

pip_install "Accelerate" "accelerate"

pip_install "Hugging Face Hub" "huggingface_hub"

# AI Development Frameworks
pip_install "LangChain" "langchain"

pip_install "LlamaIndex" "llama-index"

pip_install "Semantic Kernel" "semantic-kernel"

# Vector Databases
pip_install "ChromaDB" "chromadb"

pip_install "Pinecone" "pinecone-client"

pip_install "Qdrant" "qdrant-client"

pip_install "Weaviate" "weaviate-client"

# AI Testing and Evaluation
pip_install "Ragas" "ragas"

pip_install "DeepEval" "deepeval"

pip_install "Evaluate" "evaluate"

# AI Monitoring and Observability
pip_install "LangSmith" "langsmith"

pip_install "Weights & Biases" "wandb"

# AI Development Tools
pip_install "Gradio" "gradio"

pip_install "Streamlit" "streamlit"

pip_install "Chainlit" "chainlit"

pip_install "Jupyter" "jupyter"

# Model Serving and Deployment
pip_install "BentoML" "bentoml"

pip_install "MLflow" "mlflow"

# AI Media Generation
pip_install "ElevenLabs SDK" "elevenlabs"

# AI Media Processing
pip_install "MoviePy" "moviepy"

pip_install "VidGear" "vidgear"

pip_install "ImageIO" "imageio"

pip_install "PyAV" "av"
