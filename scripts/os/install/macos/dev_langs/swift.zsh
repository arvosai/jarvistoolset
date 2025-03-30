#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Add warning function if not already defined
print_warning() {
    print_in_yellow "  [!] $1\n"
}

print_in_purple "\n   Swift Development Tools\n\n"

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &> /dev/null; then
    print_in_purple "\n   Installing Xcode Command Line Tools\n\n"
    xcode-select --install
    print_result $? "Xcode Command Line Tools"
else
    print_success "Xcode Command Line Tools (already installed)"
fi

# Install Swift development tools
print_in_purple "\n   Installing Swift Tools\n\n"

# Install SwiftLint
if brew list --formula 2>/dev/null | grep -q "^swiftlint$"; then
    print_success "SwiftLint (already installed)"
else
    if brew install swiftlint &>/dev/null; then
        print_success "SwiftLint"
    else
        print_error "SwiftLint"
    fi
fi

# Install SwiftFormat
if brew list --formula 2>/dev/null | grep -q "^swiftformat$"; then
    print_success "SwiftFormat (already installed)"
else
    if brew install swiftformat &>/dev/null; then
        print_success "SwiftFormat"
    else
        print_error "SwiftFormat"
    fi
fi

# Install Sourcery
if brew list --formula 2>/dev/null | grep -q "^sourcery$"; then
    print_success "Sourcery (already installed)"
else
    if brew install sourcery &>/dev/null; then
        print_success "Sourcery"
    else
        print_error "Sourcery"
    fi
fi

# Install Jazzy for documentation
if gem list 2>/dev/null | grep -q "^jazzy "; then
    print_success "Jazzy (already installed)"
else
    # Try to install with gem without sudo first
    if gem install jazzy &>/dev/null; then
        print_success "Jazzy"
    else
        # Try with Homebrew
        if brew install jazzy &>/dev/null; then
            print_success "Jazzy"
        else
            print_warning "Jazzy (optional - skipped)"
        fi
    fi
fi

# Install development tools
print_in_purple "\n   Installing Development Tools\n\n"

# Install Carthage
if brew list --formula 2>/dev/null | grep -q "^carthage$"; then
    print_success "Carthage (already installed)"
else
    if brew install carthage &>/dev/null; then
        print_success "Carthage"
    else
        print_error "Carthage"
    fi
fi

# Install CocoaPods
if gem list 2>/dev/null | grep -q "^cocoapods "; then
    print_success "CocoaPods (already installed)"
else
    # Try to install with gem without sudo first
    if gem install cocoapods &>/dev/null; then
        print_success "CocoaPods"
    else
        print_error "CocoaPods"
    fi
fi

# Install Mint
if brew list --formula 2>/dev/null | grep -q "^mint$"; then
    print_success "Mint (already installed)"
else
    if brew install mint &>/dev/null; then
        print_success "Mint"
    else
        print_error "Mint"
    fi
fi

# Install Fastlane
if gem list 2>/dev/null | grep -q "^fastlane "; then
    print_success "Fastlane (already installed)"
elif brew list --formula 2>/dev/null | grep -q "^fastlane$"; then
    print_success "Fastlane (already installed via Homebrew)"
else
    # Try with Homebrew first as it avoids the conflict with wisper
    if brew install fastlane &>/dev/null; then
        print_success "Fastlane"
    else
        print_error "Fastlane"
    fi
fi

# Install xcbeautify
if brew list --formula 2>/dev/null | grep -q "^xcbeautify$"; then
    print_success "xcbeautify (already installed)"
else
    if brew install xcbeautify &>/dev/null; then
        print_success "xcbeautify"
    else
        print_error "xcbeautify"
    fi
fi

# Install xcodegen
if brew list --formula 2>/dev/null | grep -q "^xcodegen$"; then
    print_success "xcodegen (already installed)"
else
    if brew install xcodegen &>/dev/null; then
        print_success "xcodegen"
    else
        print_error "xcodegen"
    fi
fi

# Configure Swift environment
print_in_purple "\n   Configuring Swift Environment\n\n"

# Create a Swift project template
mkdir -p "$HOME/.swift_project_template/Sources"
mkdir -p "$HOME/.swift_project_template/Tests"

# Create a sample main.swift file
cat > "$HOME/.swift_project_template/Sources/main.swift" << 'EOL'
import Foundation

print("Hello, Swift World!")
EOL

# Create a sample Package.swift file
cat > "$HOME/.swift_project_template/Package.swift" << 'EOL'
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftApp",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // Dependencies go here
    ],
    targets: [
        .executableTarget(
            name: "SwiftApp",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "SwiftAppTests",
            dependencies: ["SwiftApp"],
            path: "Tests"),
    ]
)
EOL

# Create a .gitignore file
cat > "$HOME/.swift_project_template/.gitignore" << 'EOL'
.DS_Store
/.build
/Packages
/*.xcodeproj
xcuserdata/
DerivedData/
.swiftpm/
.package.resolved
EOL

echo "Swift project template created" >/dev/null
print_success "Swift development environment"

# Create modular configuration file for Swift
create_swift_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/swift.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Swift configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Swift configuration for zsh
# This file contains all Swift-related configurations
#

# Swift environment variables
export PATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH"
export TOOLCHAINS=swift

# Swift aliases
alias sb="swift build"
alias sr="swift run"
alias st="swift test"
alias sp="swift package"
alias spi="swift package init"
alias spu="swift package update"
alias swiftc="swiftc -O"

# Swift development functions
new-swift() {
    if [[ -n "$1" ]]; then
        mkdir -p "$1"
        cp -r "$HOME/.swift_project_template/"* "$1/"
        cd "$1"
        # Replace placeholder with actual project name
        sed -i '' "s/SwiftApp/$1/g" Package.swift
        git init
        git add .
        git commit -m "Initial commit"
        echo "Swift project $1 created successfully!"
    else
        echo "Please provide a project name"
    fi
}
EOL
    
    print_result $? "Created Swift configuration file"
}

# Create modular configuration
create_swift_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/swift.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the Swift config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load Swift configuration
source "$HOME/.jarvistoolset/zsh_configs/swift.zsh"
EOL
    print_result $? "Added Swift configuration to .zshrc"
fi

print_in_green "\n  Swift development environment setup complete!\n"
