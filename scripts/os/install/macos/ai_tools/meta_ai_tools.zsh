#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Meta AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Meta AI
execute "pip3 install torch" \
    "Installing PyTorch"

execute "pip3 install torchvision" \
    "Installing TorchVision"

execute "pip3 install torchaudio" \
    "Installing TorchAudio"

# Meta AI Research
execute "pip3 install fairseq" \
    "Installing Fairseq"

execute "pip3 install fairscale" \
    "Installing FairScale"

execute "pip3 install fairlearn" \
    "Installing FairLearn"

# Meta Computer Vision
execute "pip3 install detectron2" \
    "Installing Detectron2"

execute "pip3 install pytorch3d" \
    "Installing PyTorch3D"

execute "pip3 install vissl" \
    "Installing VISSL"

# Meta NLP
execute "pip3 install transformers" \
    "Installing Transformers"

execute "pip3 install datasets" \
    "Installing Datasets"

execute "pip3 install tokenizers" \
    "Installing Tokenizers"

# Meta Audio
execute "pip3 install torchaudio-models" \
    "Installing TorchAudio Models"

execute "pip3 install audiocraft" \
    "Installing AudioCraft"

execute "pip3 install encodec" \
    "Installing EnCodec"

# Meta Research Tools
execute "pip3 install hydra-core" \
    "Installing Hydra"

execute "pip3 install submitit" \
    "Installing Submitit"

execute "pip3 install fvcore" \
    "Installing FVCore"

# Meta ML Tools
execute "pip3 install ax-platform" \
    "Installing Ax Platform"

execute "pip3 install botorch" \
    "Installing BoTorch"

execute "pip3 install higher" \
    "Installing Higher"

# Meta Development
execute "pip3 install pytorch-lightning" \
    "Installing PyTorch Lightning"

execute "pip3 install torch-geometric" \
    "Installing PyTorch Geometric"

execute "pip3 install pytorch-forecasting" \
    "Installing PyTorch Forecasting"

# Meta Optimization
execute "pip3 install functorch" \
    "Installing FuncTorch"

execute "pip3 install torchx" \
    "Installing TorchX"

execute "pip3 install torch-tb-profiler" \
    "Installing PyTorch Profiler"
