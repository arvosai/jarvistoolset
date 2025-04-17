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
