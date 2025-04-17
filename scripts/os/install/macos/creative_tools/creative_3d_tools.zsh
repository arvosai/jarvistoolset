#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Creative and 3D Tools Installation Script
# This script installs popular creative and 3D design tools for macOS

# Source utils for helper functions
source "${SCRIPT_DIR}/utils.zsh"

log_info "Starting installation of Creative and 3D Tools"
print_in_purple "
 • Installing Creative and 3D Tools...

"

# Install Blender (3D creation suite)
if ! is_app_installed "Blender"; then
    log_info "Installing Blender..."
    print_in_blue "   Installing Blender..."
    brew install --cask blender
    if [ $? -eq 0 ]; then
        log_success "Blender installed successfully"
        print_success "Blender"
    else
        log_error "Failed to install Blender"
        print_error "Blender"
    fi
else
    log_info "Blender already installed"
    print_success "Blender already installed"
fi

# Install Autodesk Maya (3D animation, modeling, simulation)
if ! is_app_installed "Maya"; then
    log_info "Installing Autodesk Maya..."
    print_in_blue "   Installing Autodesk Maya..."
    brew install --cask autodesk-maya
    if [ $? -eq 0 ]; then
        log_success "Autodesk Maya installed successfully"
        print_success "Autodesk Maya"
    else
        log_error "Failed to install Autodesk Maya"
        print_error "Autodesk Maya"
    fi
else
    log_info "Autodesk Maya already installed"
    print_success "Autodesk Maya already installed"
fi

# Install Cinema 4D (3D modeling, animation, and rendering)
if ! is_app_installed "Cinema 4D"; then
    log_info "Installing Cinema 4D..."
    print_in_blue "   Installing Cinema 4D..."
    brew install --cask cinema-4d
    if [ $? -eq 0 ]; then
        log_success "Cinema 4D installed successfully"
        print_success "Cinema 4D"
    else
        log_error "Failed to install Cinema 4D"
        print_error "Cinema 4D"
    fi
else
    log_info "Cinema 4D already installed"
    print_success "Cinema 4D already installed"
fi

# Install ZBrush (digital sculpting tool)
if ! is_app_installed "ZBrush"; then
    log_info "Installing ZBrush..."
    print_in_blue "   Installing ZBrush..."
    brew install --cask zbrush
    if [ $? -eq 0 ]; then
        log_success "ZBrush installed successfully"
        print_success "ZBrush"
    else
        log_error "Failed to install ZBrush"
        print_error "ZBrush"
    fi
else
    log_info "ZBrush already installed"
    print_success "ZBrush already installed"
fi

# Install Houdini (3D animation and VFX)
if ! is_app_installed "Houdini"; then
    log_info "Installing Houdini..."
    print_in_blue "   Installing Houdini..."
    brew install --cask houdini
    if [ $? -eq 0 ]; then
        log_success "Houdini installed successfully"
        print_success "Houdini"
    else
        log_error "Failed to install Houdini"
        print_error "Houdini"
    fi
else
    log_info "Houdini already installed"
    print_success "Houdini already installed"
fi

# Install Substance Painter (3D painting software)
if ! is_app_installed "Substance Painter"; then
    log_info "Installing Substance Painter..."
    print_in_blue "   Installing Substance Painter..."
    brew install --cask substance-painter
    if [ $? -eq 0 ]; then
        log_success "Substance Painter installed successfully"
        print_success "Substance Painter"
    else
        log_error "Failed to install Substance Painter"
        print_error "Substance Painter"
    fi
else
    log_info "Substance Painter already installed"
    print_success "Substance Painter already installed"
fi

# Install Substance Designer (material authoring tool)
if ! is_app_installed "Substance Designer"; then
    log_info "Installing Substance Designer..."
    print_in_blue "   Installing Substance Designer..."
    brew install --cask substance-designer
    if [ $? -eq 0 ]; then
        log_success "Substance Designer installed successfully"
        print_success "Substance Designer"
    else
        log_error "Failed to install Substance Designer"
        print_error "Substance Designer"
    fi
else
    log_info "Substance Designer already installed"
    print_success "Substance Designer already installed"
fi

# Install Unity (game development platform)
if ! is_app_installed "Unity"; then
    log_info "Installing Unity..."
    print_in_blue "   Installing Unity..."
    brew install --cask unity
    if [ $? -eq 0 ]; then
        log_success "Unity installed successfully"
        print_success "Unity"
    else
        log_error "Failed to install Unity"
        print_error "Unity"
    fi
else
    log_info "Unity already installed"
    print_success "Unity already installed"
fi

# Install Unreal Engine (game development platform)
if ! is_app_installed "Unreal Engine"; then
    log_info "Installing Unreal Engine..."
    print_in_blue "   Installing Unreal Engine..."
    brew install --cask unreal-engine
    if [ $? -eq 0 ]; then
        log_success "Unreal Engine installed successfully"
        print_success "Unreal Engine"
    else
        log_error "Failed to install Unreal Engine"
        print_error "Unreal Engine"
    fi
else
    log_info "Unreal Engine already installed"
    print_success "Unreal Engine already installed"
fi

# Install Fusion 360 (3D CAD, CAM, and CAE tool)
if ! is_app_installed "Fusion 360"; then
    log_info "Installing Fusion 360..."
    print_in_blue "   Installing Fusion 360..."
    brew install --cask autodesk-fusion360
    if [ $? -eq 0 ]; then
        log_success "Fusion 360 installed successfully"
        print_success "Fusion 360"
    else
        log_error "Failed to install Fusion 360"
        print_error "Fusion 360"
    fi
else
    log_info "Fusion 360 already installed"
    print_success "Fusion 360 already installed"
fi

# Install SketchUp (3D modeling for architecture and design)
if ! is_app_installed "SketchUp"; then
    log_info "Installing SketchUp..."
    print_in_blue "   Installing SketchUp..."
    brew install --cask sketchup
    if [ $? -eq 0 ]; then
        log_success "SketchUp installed successfully"
        print_success "SketchUp"
    else
        log_error "Failed to install SketchUp"
        print_error "SketchUp"
    fi
else
    log_info "SketchUp already installed"
    print_success "SketchUp already installed"
fi

# Install Arnold Renderer (advanced rendering software)
if ! command_exists "arnold"; then
    log_info "Installing Arnold Renderer..."
    print_in_blue "   Installing Arnold Renderer..."
    brew install --cask arnold-renderer
    if [ $? -eq 0 ]; then
        log_success "Arnold Renderer installed successfully"
        print_success "Arnold Renderer"
    else
        log_error "Failed to install Arnold Renderer"
        print_error "Arnold Renderer"
    fi
else
    log_info "Arnold Renderer already installed"
    print_success "Arnold Renderer already installed"
fi

# Install V-Ray (rendering plugin)
if ! is_app_installed "V-Ray"; then
    log_info "Installing V-Ray..."
    print_in_blue "   Installing V-Ray..."
    brew install --cask vray
    if [ $? -eq 0 ]; then
        log_success "V-Ray installed successfully"
        print_success "V-Ray"
    else
        log_error "Failed to install V-Ray"
        print_error "V-Ray"
    fi
else
    log_info "V-Ray already installed"
    print_success "V-Ray already installed"
fi

# Install Marvelous Designer (3D clothing design software)
if ! is_app_installed "Marvelous Designer"; then
    log_info "Installing Marvelous Designer..."
    print_in_blue "   Installing Marvelous Designer..."
    brew install --cask marvelous-designer
    if [ $? -eq 0 ]; then
        log_success "Marvelous Designer installed successfully"
        print_success "Marvelous Designer"
    else
        log_error "Failed to install Marvelous Designer"
        print_error "Marvelous Designer"
    fi
else
    log_info "Marvelous Designer already installed"
    print_success "Marvelous Designer already installed"
fi

# Install Procreate (digital illustration app)
if ! is_app_installed "Procreate"; then
    log_info "Procreate is only available on iPad"
    print_in_blue "   Installing Procreate..."
    print_in_yellow "   Procreate is only available on iPad. Please install it from the App Store on your iPad."
    log_warning "Procreate installation skipped - only available on iPad"
else
    log_info "Procreate already installed"
    print_success "Procreate already installed"
fi

log_success "Creative and 3D Tools installation complete"
print_in_green "
 ✓ Creative and 3D Tools installation complete!
"
