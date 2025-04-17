#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Creative and Generative AI Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Image Creation and Editing
brew_cask_install "adobe-creative-cloud" "Installing Adobe Creative Cloud" true

brew_cask_install "figma" "Installing Figma" true

brew_cask_install "sketch" "Installing Sketch" true

brew_cask_install "affinity-designer" "Installing Affinity Designer" true

brew_cask_install "affinity-photo" "Installing Affinity Photo" true

brew_cask_install "blender" "Installing Blender" true

# Generative AI Image Tools
brew_cask_install "stable-diffusion-ui" "Installing Stable Diffusion UI" true

brew_cask_install "diffusionbee" "Installing DiffusionBee" true

brew_cask_install "invoke-ai" "Installing Invoke AI" true

brew_cask_install "comfyui" "Installing ComfyUI" true

brew_cask_install "fooocus" "Installing Fooocus" true

brew_cask_install "auto-photoshop" "Installing Auto Photoshop" true

# Video Creation and Editing
brew_cask_install "davinci-resolve" "Installing DaVinci Resolve" true

brew_cask_install "final-cut-pro" "Installing Final Cut Pro" true

brew_cask_install "after-effects" "Installing After Effects" true

brew_cask_install "premiere-pro" "Installing Premiere Pro" true

brew_cask_install "obs" "Installing OBS Studio" true

# Generative AI Video Tools
brew_cask_install "runway" "Installing Runway" true

brew_cask_install "d-id-studio" "Installing D-ID Studio" true

brew_cask_install "synthesia" "Installing Synthesia" true

brew_cask_install "descript" "Installing Descript" true

brew_cask_install "wonder-studio" "Installing Wonder Studio" true

# Audio Creation and Editing
brew_cask_install "logic-pro" "Installing Logic Pro" true

brew_cask_install "ableton-live" "Installing Ableton Live" true

brew_cask_install "audacity" "Installing Audacity" true

brew_cask_install "garageband" "Installing GarageBand" true

# Generative AI Audio Tools
brew_cask_install "murf-studio" "Installing Murf Studio" true

brew_cask_install "elevenlabs" "Installing ElevenLabs" true

brew_cask_install "soundraw" "Installing Soundraw" true

brew_cask_install "musicgen" "Installing MusicGen" true

brew_cask_install "audiogen" "Installing AudioGen" true

# 3D Modeling and Animation
brew_cask_install "blender" "Installing Blender" true

brew_cask_install "maya" "Installing Maya" true

brew_cask_install "cinema-4d" "Installing Cinema 4D" true

brew_cask_install "houdini" "Installing Houdini" true

brew_cask_install "zbrush" "Installing ZBrush" true

brew_cask_install "modo" "Installing Modo" true

brew_cask_install "rhino" "Installing Rhino" true

brew_cask_install "substance-3d-painter" "Installing Substance 3D Painter" true

brew_cask_install "substance-3d-designer" "Installing Substance 3D Designer" true

brew_cask_install "substance-3d-sampler" "Installing Substance 3D Sampler" true

# 3D Scanning and Photogrammetry
brew_cask_install "reality-capture" "Installing Reality Capture" true

brew_cask_install "agisoft-metashape" "Installing Agisoft Metashape" true

brew_cask_install "meshroom" "Installing Meshroom" true

brew_cask_install "scan-to-cad" "Installing Scan to CAD" true

brew_cask_install "artec-studio" "Installing Artec Studio" true

# 3D Printing and Slicing
brew_cask_install "ultimaker-cura" "Installing Ultimaker Cura" true

brew_cask_install "prusa-slicer" "Installing Prusa Slicer" true

brew_cask_install "simplify3d" "Installing Simplify3D" true

brew_cask_install "makerbot-print" "Installing MakerBot Print" true

brew_cask_install "raise3d-ideamaker" "Installing ideaMaker" true

# CAD and Engineering
brew_cask_install "fusion360" "Installing Fusion 360" true

brew_cask_install "solidworks" "Installing SOLIDWORKS" true

brew_cask_install "onshape" "Installing Onshape" true

brew_cask_install "freecad" "Installing FreeCAD" true

brew_cask_install "openscad" "Installing OpenSCAD" true

# 3D Game Development
brew_cask_install "unity-hub" "Installing Unity Hub" true

brew_cask_install "unreal-engine" "Installing Unreal Engine" true

brew_cask_install "godot" "Installing Godot" true

brew_cask_install "cryengine" "Installing CryEngine" true

brew_cask_install "lumberyard" "Installing Lumberyard" true

# 3D Visualization and Rendering
brew_cask_install "v-ray" "Installing V-Ray" true

brew_cask_install "corona-renderer" "Installing Corona Renderer" true

brew_cask_install "octane-render" "Installing Octane Render" true

brew_cask_install "redshift-render" "Installing Redshift" true

brew_cask_install "arnold-renderer" "Installing Arnold" true

# Generative AI 3D Tools
brew_cask_install "nvidia-omniverse" "Installing NVIDIA Omniverse" true

brew_cask_install "point-e" "Installing Point-E" true

brew_cask_install "get3d" "Installing GET3D" true

brew_cask_install "dreamfusion" "Installing DreamFusion" true

brew_cask_install "shap-e" "Installing Shap-E" true

brew_cask_install "magic3d" "Installing Magic3D" true

brew_cask_install "instant-3d" "Installing Instant 3D" true

brew_cask_install "nerf-studio" "Installing NeRF Studio" true

brew_cask_install "gaussian-splatting" "Installing Gaussian Splatting" true

brew_cask_install "threestudio" "Installing ThreeStudio" true

# 3D Asset Management
brew_cask_install "quixel-bridge" "Installing Quixel Bridge" true

brew_cask_install "sketchfab" "Installing Sketchfab" true

brew_cask_install "megascans-bridge" "Installing Megascans Bridge" true

brew_cask_install "turbosquid" "Installing TurboSquid" true

brew_cask_install "cgtrader" "Installing CGTrader" true

# 3D Motion Capture
brew_cask_install "rokoko" "Installing Rokoko" true

brew_cask_install "ipisoft" "Installing iPi Soft" true

brew_cask_install "perception-neuron" "Installing Perception Neuron" true

brew_cask_install "optitrack" "Installing OptiTrack" true

brew_cask_install "vicon-shogun" "Installing Vicon Shogun" true

# 3D Character Creation
brew_cask_install "character-creator" "Installing Character Creator" true

brew_cask_install "daz-studio" "Installing DAZ Studio" true

brew_cask_install "marvelous-designer" "Installing Marvelous Designer" true

brew_cask_install "fuse" "Installing Fuse" true

brew_cask_install "makehuman" "Installing MakeHuman" true

# AI-Powered 3D Animation
brew_cask_install "plask" "Installing Plask AI" true

brew_cask_install "cascadeur" "Installing Cascadeur" true

brew_cask_install "deepmotion" "Installing DeepMotion" true

brew_cask_install "mixamo" "Installing Mixamo" true

brew_cask_install "motion-library" "Installing Motion Library" true

# UI/UX Design
brew_cask_install "framer" "Installing Framer" true

brew_cask_install "principle" "Installing Principle" true

brew_cask_install "protopie" "Installing ProtoPie" true

brew_cask_install "zeplin" "Installing Zeplin" true

# Generative AI Design Tools
brew_cask_install "galileo-ai" "Installing Galileo AI" true

brew_cask_install "magicul" "Installing MagicUL" true

brew_cask_install "uizard" "Installing Uizard" true

# Writing and Content Creation
brew_cask_install "scrivener" "Installing Scrivener" true

brew_cask_install "ulysses" "Installing Ulysses" true

brew_cask_install "notion" "Installing Notion" true

# Generative AI Writing Tools
brew_cask_install "jasper" "Installing Jasper" true

brew_cask_install "copy-ai" "Installing Copy.ai" true

brew_cask_install "grammarly-desktop" "Installing Grammarly" true

brew_cask_install "writesonic" "Installing Writesonic" true

# Collaboration and Asset Management
brew_cask_install "adobe-creative-cloud-cleaner-tool" "Installing Adobe CC Cleaner" true

brew_cask_install "dropbox" "Installing Dropbox" true

brew_cask_install "google-drive" "Installing Google Drive" true

brew_cask_install "asana" "Installing Asana" true

# Creative Development Tools
brew_cask_install "processing" "Installing Processing" true

brew_cask_install "touchdesigner" "Installing TouchDesigner" true

brew_cask_install "p5js" "Installing p5.js" true

brew_cask_install "arduino" "Installing Arduino IDE" true

# Color and Asset Management
brew_cask_install "colorsnapper" "Installing ColorSnapper" true

brew_cask_install "sip" "Installing Sip" true

brew_cask_install "iconjar" "Installing IconJar" true

brew_cask_install "imageoptim" "Installing ImageOptim" true
