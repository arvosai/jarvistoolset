#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Machine Learning Development Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core ML Libraries
execute "pip3 install numpy" \
    "Installing NumPy"

execute "pip3 install pandas" \
    "Installing Pandas"

execute "pip3 install scipy" \
    "Installing SciPy"

execute "pip3 install scikit-learn" \
    "Installing Scikit-learn"

# Deep Learning Frameworks
execute "pip3 install tensorflow" \
    "Installing TensorFlow"

execute "pip3 install torch torchvision torchaudio" \
    "Installing PyTorch"

execute "pip3 install jax jaxlib" \
    "Installing JAX"

execute "pip3 install flax" \
    "Installing Flax"

execute "pip3 install keras" \
    "Installing Keras"

# Model Development Tools
execute "pip3 install pytorch-lightning" \
    "Installing PyTorch Lightning"

execute "pip3 install fastai" \
    "Installing Fast.ai"

execute "pip3 install transformers" \
    "Installing Hugging Face Transformers"

execute "pip3 install optuna" \
    "Installing Optuna"

execute "pip3 install ray[tune]" \
    "Installing Ray Tune"

# Data Processing
execute "pip3 install dask" \
    "Installing Dask"

execute "pip3 install vaex" \
    "Installing Vaex"

execute "pip3 install polars" \
    "Installing Polars"

execute "pip3 install modin" \
    "Installing Modin"

# Feature Engineering
execute "pip3 install feature-engine" \
    "Installing Feature Engine"

execute "pip3 install category_encoders" \
    "Installing Category Encoders"

execute "pip3 install featuretools" \
    "Installing Featuretools"

# Visualization
execute "pip3 install matplotlib" \
    "Installing Matplotlib"

execute "pip3 install seaborn" \
    "Installing Seaborn"

execute "pip3 install plotly" \
    "Installing Plotly"

execute "pip3 install bokeh" \
    "Installing Bokeh"

# ML Ops Tools
execute "pip3 install mlflow" \
    "Installing MLflow"

execute "pip3 install wandb" \
    "Installing Weights & Biases"

execute "pip3 install dvc" \
    "Installing DVC"

execute "pip3 install neptune-client" \
    "Installing Neptune"

# Model Serving
execute "pip3 install bentoml" \
    "Installing BentoML"

execute "pip3 install fastapi" \
    "Installing FastAPI"

execute "pip3 install streamlit" \
    "Installing Streamlit"

execute "pip3 install gradio" \
    "Installing Gradio"

# Model Optimization
execute "pip3 install onnx" \
    "Installing ONNX"

execute "pip3 install tensorrt" \
    "Installing TensorRT"

execute "pip3 install tensorflow-model-optimization" \
    "Installing TensorFlow Model Optimization"

# Experiment Tracking
execute "pip3 install sacred" \
    "Installing Sacred"

execute "pip3 install tensorboard" \
    "Installing TensorBoard"

execute "pip3 install aim" \
    "Installing Aim"

# AutoML Tools
execute "pip3 install autokeras" \
    "Installing AutoKeras"

execute "pip3 install auto-sklearn" \
    "Installing Auto-sklearn"

execute "pip3 install pycaret" \
    "Installing PyCaret"

# Time Series
execute "pip3 install prophet" \
    "Installing Prophet"

execute "pip3 install statsmodels" \
    "Installing StatsModels"

execute "pip3 install sktime" \
    "Installing sktime"

# Natural Language Processing
execute "pip3 install nltk" \
    "Installing NLTK"

execute "pip3 install spacy" \
    "Installing spaCy"

execute "pip3 install gensim" \
    "Installing Gensim"

# Computer Vision
execute "pip3 install opencv-python" \
    "Installing OpenCV"

execute "pip3 install albumentations" \
    "Installing Albumentations"

execute "pip3 install imgaug" \
    "Installing imgaug"

# Reinforcement Learning
execute "pip3 install gymnasium" \
    "Installing Gymnasium"

execute "pip3 install stable-baselines3" \
    "Installing Stable Baselines3"

execute "pip3 install rllib" \
    "Installing RLlib"
