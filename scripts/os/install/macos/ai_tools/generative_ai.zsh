#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Generative AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Image Generation
execute "pip3 install diffusers" \
    "Installing Diffusers for Stable Diffusion"

execute "pip3 install accelerate" \
    "Installing Accelerate for optimized inference"

execute "pip3 install safetensors" \
    "Installing Safetensors"

# Pipeline Tools
execute "pip3 install pipecat" \
    "Installing Pipecat for AI image pipelines"

execute "pip3 install imaginairy" \
    "Installing Imaginairy for image generation"

execute "pip3 install cog" \
    "Installing Cog for ML model containers"

execute "pip3 install kornia" \
    "Installing Kornia for computer vision"

execute "pip3 install einops" \
    "Installing Einops for tensor operations"

execute "pip3 install pytorch-lightning" \
    "Installing PyTorch Lightning"

execute "pip3 install k-diffusion" \
    "Installing K-Diffusion"

execute "pip3 install compel" \
    "Installing Compel for prompt engineering"

# Image Pipeline Optimization
execute "pip3 install xformers" \
    "Installing xFormers for efficient transformers"

execute "pip3 install triton" \
    "Installing Triton for GPU optimization"

execute "pip3 install torch-ema" \
    "Installing Torch EMA"

# Image Quality and Processing
execute "pip3 install realesrgan" \
    "Installing Real-ESRGAN for upscaling"

execute "pip3 install basicsr" \
    "Installing BasicSR for restoration"

execute "pip3 install invisible-watermark" \
    "Installing Invisible Watermark"

execute "pip3 install transformers[torch]" \
    "Installing Transformers with Torch support"

# Pipeline Management and UI
execute "pip3 install gradio" \
    "Installing Gradio for UI creation"

execute "pip3 install streamlit" \
    "Installing Streamlit for web apps"

execute "pip3 install fastapi" \
    "Installing FastAPI for APIs"

execute "pip3 install uvicorn" \
    "Installing Uvicorn ASGI server"

# Image Processing and Computer Vision
execute "pip3 install opencv-python" \
    "Installing OpenCV"

execute "pip3 install pillow" \
    "Installing Pillow"

execute "pip3 install albumentations" \
    "Installing Albumentations"

execute "pip3 install scikit-image" \
    "Installing Scikit-image"

# Quality Metrics
execute "pip3 install torch-fidelity" \
    "Installing Torch-Fidelity"

execute "pip3 install lpips" \
    "Installing LPIPS for perceptual similarity"

execute "pip3 install cleanfid" \
    "Installing Clean-FID"

# Audio and Speech
execute "pip3 install torchaudio" \
    "Installing TorchAudio"

execute "pip3 install speechrecognition" \
    "Installing Speech Recognition"

execute "pip3 install whisper-openai" \
    "Installing OpenAI Whisper"

execute "pip3 install TTS" \
    "Installing Mozilla TTS"

execute "pip3 install librosa" \
    "Installing Librosa for audio processing"

execute "pip3 install soundfile" \
    "Installing SoundFile"

# Music Generation
execute "pip3 install mubert" \
    "Installing Mubert API"

execute "pip3 install audiocraft" \
    "Installing Meta's AudioCraft"

# Video Generation
execute "pip3 install moviepy" \
    "Installing MoviePy"

execute "pip3 install torch-intermediate-layer-getter" \
    "Installing Torch Layer Getter"

# Text Generation and Processing
execute "pip3 install sentence-transformers" \
    "Installing Sentence Transformers"

execute "pip3 install tokenizers" \
    "Installing Tokenizers"

# 3D Generation
execute "pip3 install pytorch3d" \
    "Installing PyTorch3D"

execute "pip3 install trimesh" \
    "Installing Trimesh"

# Model Management
execute "pip3 install huggingface_hub" \
    "Installing Hugging Face Hub"
