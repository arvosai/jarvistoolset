#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../../../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Node.js\n\n"

# Install NVM (Node Version Manager)
install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        print_info "Installing NVM..."
        
        # Install NVM
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
        
        # Source NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        print_result $? "NVM installation"
    else
        print_success "NVM is already installed"
        
        # Source NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi
    
    # Ensure NVM is available in this script
    if ! command -v nvm &>/dev/null; then
        print_warning "NVM command not found, attempting to load NVM again..."
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        # Check again if NVM is available
        if ! command -v nvm &>/dev/null; then
            print_error "Failed to load NVM. Please restart your terminal and try again."
            return 1
        fi
    fi
}

# Install Node.js using NVM
install_nodejs() {
    # Install the LTS version of Node.js
    print_info "Installing Node.js LTS..."
    
    nvm install --lts
    nvm use --lts
    nvm alias default node
    
    print_result $? "Node.js LTS installation"
    
    # Display Node.js and npm versions
    node --version
    npm --version
}

# Helper function to install npm packages
npm_install() {
    local PACKAGE_READABLE_NAME="$1"
    local PACKAGE="$2"

    if npm list -g "$PACKAGE" &> /dev/null; then
        print_success "$PACKAGE_READABLE_NAME"
    else
        execute "npm install -g $PACKAGE" "$PACKAGE_READABLE_NAME"
    fi
}

# Install global npm packages
install_npm_packages() {
    print_in_purple "\n   Installing Global npm Packages\n\n"
    
    # Update npm
    execute "npm install -g npm@latest" "npm update"
    
    # Install essential global packages
    npm_install "Yarn" "yarn"
    npm_install "pnpm" "pnpm"
    npm_install "TypeScript" "typescript"
    npm_install "ts-node" "ts-node"
    npm_install "ESLint" "eslint"
    npm_install "Prettier" "prettier"
    npm_install "nodemon" "nodemon"
    npm_install "http-server" "http-server"
    npm_install "npm-check-updates" "npm-check-updates"
    npm_install "serve" "serve"
    npm_install "json-server" "json-server"
    npm_install "npm-why" "npm-why"
    npm_install "npm-check" "npm-check"
    npm_install "depcheck" "depcheck"
    npm_install "madge" "madge"
    
    # Framework CLIs
    npm_install "create-react-app" "create-react-app"
    npm_install "create-next-app" "create-next-app"
    npm_install "create-vite" "create-vite"
    npm_install "Vue CLI" "@vue/cli"
    npm_install "Angular CLI" "@angular/cli"
    npm_install "Gatsby CLI" "gatsby-cli"
    npm_install "Svelte CLI" "svelte-cli"
    npm_install "Nx" "nx"
}

# Create modular configuration file for Node.js
create_nodejs_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/nodejs.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Node.js configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Node.js configuration for zsh
# This file contains all Node.js-related configurations
#

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Node.js version management aliases
alias node-lts='nvm use --lts'
alias node-latest='nvm use node'
alias node-versions='nvm ls'
alias node-install='nvm install'
alias node-default='nvm alias default'

# npm aliases
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nu='npm update'
alias nug='npm update -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nd='npm run dev'
alias nl='npm run lint'
alias nf='npm run format'
alias nci='npm ci'
alias nout='npm outdated'
alias nls='npm list --depth=0'
alias nlsg='npm list -g --depth=0'
alias naud='npm audit'
alias naudf='npm audit fix'

# yarn aliases
alias yi='yarn install'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yag='yarn global add'
alias yu='yarn upgrade'
alias yug='yarn global upgrade'
alias yr='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yd='yarn dev'
alias yl='yarn lint'
alias yf='yarn format'
alias yout='yarn outdated'
alias yls='yarn list --depth=0'
alias ylsg='yarn global list'
alias yaud='yarn audit'

# pnpm aliases
alias pi='pnpm install'
alias pa='pnpm add'
alias pad='pnpm add -D'
alias pag='pnpm add -g'
alias pu='pnpm update'
alias pug='pnpm update -g'
alias pr='pnpm run'
alias ps='pnpm start'
alias pt='pnpm test'
alias pb='pnpm run build'
alias pd='pnpm run dev'
alias pl='pnpm run lint'
alias pf='pnpm run format'
alias pout='pnpm outdated'
alias pls='pnpm list --depth=0'
alias plsg='pnpm list -g --depth=0'
alias paud='pnpm audit'

# Node.js project utilities
create-node-project() {
    local project_name=$1
    local template=${2:-"basic"}
    
    if [ -z "$project_name" ]; then
        echo "Error: Project name is required."
        echo "Usage: create-node-project <project-name> [template]"
        echo "Available templates: basic, express, typescript, ts-express"
        return 1
    fi
    
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    case "$template" in
        "basic")
            # Initialize npm
            npm init -y
            
            # Create basic structure
            mkdir -p src
            touch src/index.js
            
            # Add start script
            sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "echo \\"Error: no test specified\\" && exit 1",\n    "start": "node src\/index.js"/' package.json
            
            # Create basic index.js
            cat > src/index.js << 'EOF'
console.log('Hello, Node.js!');
EOF
            
            # Create README
            cat > README.md << 'EOF'
# Node.js Project

A basic Node.js project.

## Getting Started

1. Install dependencies: `npm install`
2. Run the project: `npm start`
EOF
            
            # Create .gitignore
            cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Dependency directories
node_modules/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/

# Editor directories and files
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
EOF
            ;;
            
        "express")
            # Initialize npm
            npm init -y
            
            # Install dependencies
            npm install express
            npm install --save-dev nodemon
            
            # Create basic structure
            mkdir -p src
            touch src/index.js
            
            # Add scripts
            sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "echo \\"Error: no test specified\\" && exit 1",\n    "start": "node src\/index.js",\n    "dev": "nodemon src\/index.js"/' package.json
            
            # Create basic Express app
            cat > src/index.js << 'EOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({ message: 'Hello from Express!' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
EOF
            
            # Create README
            cat > README.md << 'EOF'
# Express.js Project

A basic Express.js project.

## Getting Started

1. Install dependencies: `npm install`
2. Run in development mode: `npm run dev`
3. Run in production mode: `npm start`

## API Endpoints

- GET / - Returns a welcome message
EOF
            
            # Create .gitignore
            cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Dependency directories
node_modules/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/

# Editor directories and files
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
EOF
            ;;
            
        "typescript")
            # Initialize npm
            npm init -y
            
            # Install dependencies
            npm install --save-dev typescript ts-node @types/node nodemon
            
            # Create tsconfig.json
            npx tsc --init --rootDir src --outDir dist --esModuleInterop --resolveJsonModule --lib es6 --module commonjs --allowJs true --noImplicitAny true
            
            # Create basic structure
            mkdir -p src
            touch src/index.ts
            
            # Add scripts
            sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "echo \\"Error: no test specified\\" && exit 1",\n    "start": "node dist\/index.js",\n    "build": "tsc",\n    "dev": "nodemon --exec ts-node src\/index.ts"/' package.json
            
            # Create basic TypeScript file
            cat > src/index.ts << 'EOF'
const greeting: string = 'Hello, TypeScript!';
console.log(greeting);
EOF
            
            # Create README
            cat > README.md << 'EOF'
# TypeScript Project

A basic TypeScript project.

## Getting Started

1. Install dependencies: `npm install`
2. Run in development mode: `npm run dev`
3. Build the project: `npm run build`
4. Run the built project: `npm start`
EOF
            
            # Create .gitignore
            cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Dependency directories
node_modules/

# TypeScript cache
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/

# Editor directories and files
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
EOF
            ;;
            
        "ts-express")
            # Initialize npm
            npm init -y
            
            # Install dependencies
            npm install express
            npm install --save-dev typescript ts-node @types/node @types/express nodemon
            
            # Create tsconfig.json
            npx tsc --init --rootDir src --outDir dist --esModuleInterop --resolveJsonModule --lib es6 --module commonjs --allowJs true --noImplicitAny true
            
            # Create basic structure
            mkdir -p src
            touch src/index.ts
            
            # Add scripts
            sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"test": "echo \\"Error: no test specified\\" && exit 1",\n    "start": "node dist\/index.js",\n    "build": "tsc",\n    "dev": "nodemon --exec ts-node src\/index.ts"/' package.json
            
            # Create basic Express app with TypeScript
            cat > src/index.ts << 'EOF'
import express, { Request, Response } from 'express';

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
  res.json({ message: 'Hello from Express with TypeScript!' });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
EOF
            
            # Create README
            cat > README.md << 'EOF'
# Express.js with TypeScript Project

A basic Express.js project with TypeScript.

## Getting Started

1. Install dependencies: `npm install`
2. Run in development mode: `npm run dev`
3. Build the project: `npm run build`
4. Run the built project: `npm start`

## API Endpoints

- GET / - Returns a welcome message
EOF
            
            # Create .gitignore
            cat > .gitignore << 'EOF'
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Dependency directories
node_modules/

# TypeScript cache
*.tsbuildinfo

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/

# Editor directories and files
.vscode/
.idea/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
EOF
            ;;
            
        *)
            echo "Unknown template: $template"
            echo "Available templates: basic, express, typescript, ts-express"
            return 1
            ;;
    esac
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Node.js project '${project_name}' created successfully with '${template}' template!"
}

# Create Vite project with various templates
create-vite-app() {
    local project_name=$1
    local template=${2:-"react"}
    
    if [ -z "$project_name" ]; then
        echo "Error: Project name is required."
        echo "Usage: create-vite-app <project-name> [template]"
        echo "Available templates: vanilla, vanilla-ts, react, react-ts, vue, vue-ts, preact, preact-ts, lit, lit-ts, svelte, svelte-ts"
        return 1
    fi
    
    npx create-vite "$project_name" --template "$template"
    
    cd "$project_name" || return
    npm install
    
    echo "Vite app '$project_name' created successfully with $template template!"
}
EOL
    
    print_result $? "Created Node.js configuration file"
}

# Main function
main() {
    install_nvm
    install_nodejs
    install_npm_packages
    
    # Create modular configuration
    create_nodejs_config
    
    # Check if .zshrc is already sourcing the modular configs
    if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/nodejs.zsh\"" "$HOME/.zshrc"; then
        # Add a line to source the Node.js config in .zshrc
        cat >> "$HOME/.zshrc" << 'EOL'
# Load Node.js configuration
source "$HOME/.jarvistoolset/zsh_configs/nodejs.zsh"
EOL
        print_result $? "Added Node.js configuration to .zshrc"
    fi
    
    print_in_green "\n  Node.js development environment setup complete!\n"
}

# Run main function
main
