#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   NVIDIA Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# CUDA Toolkit
execute "brew install cuda" \
    "Installing CUDA Toolkit"

execute "brew install cuda-tools" \
    "Installing CUDA Development Tools"

# Deep Learning Frameworks
execute "pip3 install cupy-cuda12x" \
    "Installing CuPy for CUDA"

execute "pip3 install nvidia-cuda-runtime-cu12" \
    "Installing CUDA Runtime"

execute "pip3 install nvidia-cuda-nvrtc-cu12" \
    "Installing CUDA NVRTC"

execute "pip3 install nvidia-cublas-cu12" \
    "Installing cuBLAS"

execute "pip3 install nvidia-cudnn-cu12" \
    "Installing cuDNN"

execute "pip3 install nvidia-cufft-cu12" \
    "Installing cuFFT"

execute "pip3 install nvidia-curand-cu12" \
    "Installing cuRAND"

execute "pip3 install nvidia-cusolver-cu12" \
    "Installing cuSOLVER"

execute "pip3 install nvidia-cusparse-cu12" \
    "Installing cuSPARSE"

execute "pip3 install nvidia-nccl-cu12" \
    "Installing NCCL"

# NVIDIA Deep Learning Libraries
execute "pip3 install nvidia-dali-cuda120" \
    "Installing NVIDIA DALI"

execute "pip3 install nvidia-tensorrt" \
    "Installing TensorRT"

execute "pip3 install nvidia-apex" \
    "Installing NVIDIA Apex"

execute "pip3 install nvidia-pyindex" \
    "Installing NVIDIA PyIndex"

# NVIDIA Optimization Tools
execute "pip3 install triton" \
    "Installing Triton"

execute "pip3 install cutlass" \
    "Installing CUTLASS"

execute "pip3 install cudf-cu12" \
    "Installing cuDF"

execute "pip3 install cuml-cu12" \
    "Installing cuML"

execute "pip3 install cugraph-cu12" \
    "Installing cuGraph"

# NVIDIA Monitoring and Profiling
execute "pip3 install nvidia-ml-py" \
    "Installing NVIDIA Management Library"

execute "pip3 install pynvml" \
    "Installing PyNVML"

# NVIDIA Container Tools
execute "brew install nvidia-container-toolkit" \
    "Installing NVIDIA Container Toolkit"

# NVIDIA Development Tools
execute "pip3 install numba" \
    "Installing Numba"

execute "pip3 install cupy" \
    "Installing CuPy"

execute "pip3 install pycuda" \
    "Installing PyCUDA"

# NVIDIA AI Tools
execute "pip3 install torch --extra-index-url https://download.pytorch.org/whl/cu121" \
    "Installing PyTorch with CUDA support"

execute "pip3 install nvidia-tensorflow" \
    "Installing NVIDIA TensorFlow"

execute "pip3 install nvidia-rapids" \
    "Installing RAPIDS"

execute "pip3 install nvidia-modulus" \
    "Installing NVIDIA Modulus"

execute "pip3 install nvidia-tao" \
    "Installing NVIDIA TAO Toolkit"
