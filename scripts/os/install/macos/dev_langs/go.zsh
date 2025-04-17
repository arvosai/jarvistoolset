#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Go

"

brew_install "Go" "go"

# Create modular configuration file for Go
create_go_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/go.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Go configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh

# Go configuration

# Set Go environment variables
export GOPATH="$HOME/go"
export GOROOT="$(brew --prefix go)/libexec"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# Create Go workspace directories if they don't exist
mkdir -p "$GOPATH/src"
mkdir -p "$GOPATH/bin"
mkdir -p "$GOPATH/pkg"

# Go aliases
alias gob="go build"
alias gor="go run"
alias got="go test"
alias goc="go clean"
alias goi="go install"
alias gof="go fmt"
alias god="go doc"
alias gol="go list"
alias gomod="go mod"
alias goget="go get"
alias gotest="go test ./..."
alias gobench="go test -bench=."
alias goclean="go clean -i -r"
alias gocover="go test -cover"
alias goprofile="go test -cpuprofile=cpu.prof -memprofile=mem.prof"

# Function to create a new Go project
go_new_project() {
    if [ $# -lt 1 ]; then
        echo "Usage: go_new_project <project_name> [module_path]"
        return 1
    fi
    
    local project_name="$1"
    local module_path="${2:-github.com/$(whoami)/$project_name}"
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return 1
    
    # Initialize Go module
    go mod init "$module_path"
    
    # Create basic directory structure
    mkdir -p cmd pkg internal
    
    # Create main.go
    cat > cmd/main.go << 'EOF'
package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, Go!")
}
EOF
    
    # Create README.md
    cat > README.md << EOF
# $project_name

A Go project.

## Usage

\`\`\`
go run cmd/main.go
\`\`\`
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Go project '$project_name' created successfully!"
}
EOL
    
    print_result $? "Created Go configuration file"
}

# Create Go workspace directories
mkdir -p "$HOME/go/src"
mkdir -p "$HOME/go/bin"
mkdir -p "$HOME/go/pkg"

# Install Go tools
print_in_purple "
   Installing Go Tools

"

# Setup GOROOT and GOPATH for Go tools
export GOROOT="$(brew --prefix go)/libexec"
export PATH="$GOROOT/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Install essential Go tools
go_install() {
    declare -r PACKAGE="$1"
    declare -r PACKAGE_READABLE_NAME="$2"
    declare -r BINARY_NAME="${3:-$(basename "$PACKAGE")}"

    if command -v "$BINARY_NAME" &> /dev/null; then
        print_success "$PACKAGE_READABLE_NAME (already installed)"
    else
        # Check if package already includes @latest
        if [[ "$PACKAGE" == *"@latest"* ]]; then
            go install "$PACKAGE" > /dev/null 2>&1 && print_success "$PACKAGE_READABLE_NAME" || print_error "Failed to install $PACKAGE_READABLE_NAME"
        else
            go install "$PACKAGE@latest" > /dev/null 2>&1 && print_success "$PACKAGE_READABLE_NAME" || print_error "Failed to install $PACKAGE_READABLE_NAME"
        fi
    fi
}

# Install Go tools with proper binary names
go_install "golang.org/x/tools/gopls" "Go Language Server" "gopls"
go_install "github.com/go-delve/delve/cmd/dlv" "Go Debugger" "dlv"
go_install "golang.org/x/lint/golint" "Go Linter" "golint"
go_install "github.com/golangci/golangci-lint/cmd/golangci-lint" "GolangCI Lint" "golangci-lint"
go_install "github.com/fatih/gomodifytags" "Go Modify Tags" "gomodifytags"
go_install "github.com/josharian/impl" "Go Implementation Generator" "impl"
go_install "github.com/cweill/gotests/gotests" "Go Test Generator" "gotests"
go_install "github.com/haya14busa/goplay/cmd/goplay" "Go Playground" "goplay"
go_install "github.com/stamblerre/gocode" "Go Code" "gocode"
go_install "github.com/ramya-rao-a/go-outline" "Go Outline" "go-outline"
go_install "github.com/uudashr/gopkgs/v2/cmd/gopkgs" "Go Packages" "gopkgs"

# Create modular configuration
create_go_config

print_in_green "
  Go development environment setup complete!
"
