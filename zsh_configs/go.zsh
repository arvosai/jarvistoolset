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
