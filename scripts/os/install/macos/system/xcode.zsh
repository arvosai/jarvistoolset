#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../../../scripts/os/utils.zsh"
source "${SCRIPT_DIR}/../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

agree_with_xcode_licence() {

    # Automatically agree to the terms of the `Xcode` license.


    sudo xcodebuild -license accept &> /dev/null
    print_result $? "Agreeing to the terms of the Xcode license"

}

are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}

install_xcode() {

    # If necessary, prompt user to install `Xcode`.

    if ! is_xcode_installed; then
        open "macappstores://itunes.apple.com/en/app/xcode/id497799835"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until `Xcode` is installed.

    while ! is_xcode_installed; do
        sleep 5
    done
    print_result 0 "Xcode"

}

install_xcode_command_line_tools() {

    # If necessary, prompt user to install
    # the `Xcode Command Line Tools`.

    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the `Xcode Command Line Tools` are installed.

    while ! are_xcode_command_line_tools_installed; do
        sleep 5
    done
    print_result 0 "Xcode Command Line Tools"

}

is_xcode_installed() {
    [ -d "/Applications/Xcode.app" ]
}

set_xcode_developer_directory() {

    # Point the `xcode-select` developer directory to
    # the appropriate directory from within `Xcode.app`.


    sudo xcode-select -switch "/Applications/Xcode.app/Contents/Developer" &> /dev/null
    print_result $? "Pointing 'xcode-select' to the correct development directory within Xcode.app"

}

# Create modular configuration file for Xcode
create_xcode_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/xcode.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Xcode configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Xcode configuration for zsh
# This file contains all Xcode-related configurations
#

# Xcode environment variables
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
export PATH="$DEVELOPER_DIR/usr/bin:$PATH"
export PATH="$DEVELOPER_DIR/Tools:$PATH"

# Xcode aliases
alias xcb="xcodebuild"
alias xcr="xcrun"
alias xcs="xcode-select"
alias xcp="xcode-select --print-path"
alias xcopen="open -a Xcode"
alias xcclean="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias xcdd="cd ~/Library/Developer/Xcode/DerivedData"
alias xcarchives="cd ~/Library/Developer/Xcode/Archives"

# Xcode functions
xcnew() {
    if [ $# -lt 2 ]; then
        echo "Usage: xcnew <project_name> <organization_identifier> [--swift | --objc]"
        return 1
    fi
    
    local project_name=$1
    local org_identifier=$2
    local language="swift"
    
    if [[ "$3" == "--objc" ]]; then
        language="objc"
    fi
    
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    if [[ "$language" == "swift" ]]; then
        swift package init --type executable
        echo "Swift project '$project_name' created"
    else
        # Create basic Objective-C project structure
        mkdir -p "$project_name/Classes" "$project_name/Resources"
        
        # Create main.m
        cat > "$project_name/main.m" << EOF
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
    }
    return 0;
}
EOF
        echo "Objective-C project '$project_name' created"
    fi
    
    # Create a basic .gitignore for Xcode projects
    cat > ".gitignore" << EOF
# Xcode
#
# gitignore contributors: remember to update Global/Xcode.gitignore, Objective-C.gitignore & Swift.gitignore

## User settings
xcuserdata/

## compatibility with Xcode 8 and earlier (ignoring not required starting Xcode 9)
*.xcscmblueprint
*.xccheckout

## compatibility with Xcode 3 and earlier (ignoring not required starting Xcode 4)
build/
DerivedData/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3

## Obj-C/Swift specific
*.hmap

## App packaging
*.ipa
*.dSYM.zip
*.dSYM

## Playgrounds
timeline.xctimeline
playground.xcworkspace

# Swift Package Manager
#
# Add this line if you want to avoid checking in source code from Swift Package Manager dependencies.
# Packages/
# Package.pins
# Package.resolved
# *.xcodeproj
#
# Xcode automatically generates this directory with a .xcworkspacedata file and xcuserdata
# hence it is not needed unless you have added a package configuration file to your project
.swiftpm

.build/

# CocoaPods
#
# We recommend against adding the Pods directory to your .gitignore. However
# you should judge for yourself, the pros and cons are mentioned at:
# https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
#
Pods/
#
# Add this line if you want to avoid checking in source code from the Xcode workspace
# *.xcworkspace

# Carthage
#
# Add this line if you want to avoid checking in source code from Carthage dependencies.
# Carthage/Checkouts

Carthage/Build/

# Accio dependency management
Dependencies/
.accio/

# fastlane
#
# It is recommended to not store the screenshots in the git repo.
# Instead, use fastlane to re-generate the screenshots whenever they are needed.
# For more information about the recommended setup visit:
# https://docs.fastlane.tools/best-practices/source-control/#source-control

fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output

# Code Injection
#
# After new code Injection tools there's a generated folder /iOSInjectionProject
# https://github.com/johnno1962/injectionforxcode

iOSInjectionProject/
EOF
    
    # Initialize git repository
    git init
    git add .
    git commit -m "Initial commit"
    
    # Open in Xcode if available
    if [ -d "/Applications/Xcode.app" ]; then
        open -a Xcode .
    fi
}

# Function to open Simulator
simulator() {
    open -a Simulator
}

# Function to reset iOS Simulator
reset_simulator() {
    osascript -e 'tell application "Simulator" to quit'
    xcrun simctl erase all
    open -a Simulator
    echo "iOS Simulator has been reset"
}
EOL
    
    print_result $? "Created Xcode configuration file"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "   Xcode\n\n"

    install_xcode_command_line_tools
    install_xcode
    set_xcode_developer_directory
    agree_with_xcode_licence
    
    # Create modular configuration
    create_xcode_config
    
    # Check if oh-my-zsh.zsh is already sourcing the modular configs
    if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/xcode.zsh\"" "$HOME/.zshrc"; then
        # Add a line to source the Xcode config in .zshrc if oh-my-zsh.zsh isn't handling it
        cat >> "$HOME/.zshrc" << 'EOL'
# Load Xcode configuration
source "$HOME/.jarvistoolset/zsh_configs/xcode.zsh"
EOL
        print_result $? "Added Xcode configuration to .zshrc"
    fi
    
    print_in_green "\n  Xcode setup complete!\n"
}

main
