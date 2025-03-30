#!/bin/zsh
#
# Node.js configuration for zsh
# This file contains all Node.js-related configurations
#

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Node.js aliases
alias nvm-ls="nvm ls"
alias nvm-lts="nvm install --lts"
alias nvm-latest="nvm install node"
alias npm-ls="npm list -g --depth=0"
alias npm-update="npm update -g"
alias npm-outdated="npm outdated -g"
alias yarn-global="yarn global"
alias pnpm-global="pnpm add -g"

# Node.js project creation functions
new-node-project() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-node-project <project-name> [--ts|--js]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--js"}
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Initialize npm project
    npm init -y
    
    # Create basic project structure
    mkdir -p src
    mkdir -p test
    
    if [[ "$project_type" == "--ts" ]]; then
        # TypeScript project
        npm install --save-dev typescript ts-node @types/node jest ts-jest @types/jest
        
        # Create tsconfig.json
        cat > "tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "es2020",
    "module": "commonjs",
    "lib": ["es2020"],
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "**/*.test.ts"]
}
EOF
        
        # Create index.ts
        cat > "src/index.ts" << EOF
/**
 * Main entry point for the application
 */
export function greet(name: string): string {
  return \`Hello, \${name}!\`;
}

// Run if this file is executed directly
if (require.main === module) {
  console.log(greet('World'));
}
EOF
        
        # Create test file
        cat > "test/index.test.ts" << EOF
import { greet } from '../src/index';

describe('greet', () => {
  it('should return a greeting message', () => {
    expect(greet('Test')).toBe('Hello, Test!');
  });
});
EOF
        
        # Update package.json scripts
        npm pkg set scripts.build="tsc"
        npm pkg set scripts.start="node dist/index.js"
        npm pkg set scripts.dev="ts-node src/index.ts"
        npm pkg set scripts.test="jest"
        npm pkg set scripts.lint="eslint src --ext .ts"
        
    else
        # JavaScript project
        npm install --save-dev jest
        
        # Create index.js
        cat > "src/index.js" << EOF
/**
 * Main entry point for the application
 */
function greet(name) {
  return \`Hello, \${name}!\`;
}

// Export for use in other files
module.exports = { greet };

// Run if this file is executed directly
if (require.main === module) {
  console.log(greet('World'));
}
EOF
        
        # Create test file
        cat > "test/index.test.js" << EOF
const { greet } = require('../src/index');

describe('greet', () => {
  it('should return a greeting message', () => {
    expect(greet('Test')).toBe('Hello, Test!');
  });
});
EOF
        
        # Update package.json scripts
        npm pkg set scripts.start="node src/index.js"
        npm pkg set scripts.test="jest"
    fi
    
    # Create .gitignore
    cat > ".gitignore" << EOF
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Dependency directories
node_modules/

# Build output
dist/
build/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Coverage directory
coverage/

# Editor directories and files
.idea/
.vscode/
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?
.DS_Store
EOF
    
    # Create README.md
    cat > "README.md" << EOF
# $project_name

A Node.js project.

## Installation

\`\`\`bash
npm install
\`\`\`

## Usage

\`\`\`bash
npm start
\`\`\`

## Development

\`\`\`bash
npm run dev
\`\`\`

## Testing

\`\`\`bash
npm test
\`\`\`
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Node.js project '$project_name' created successfully!"
}

new-react-app() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-react-app <project-name> [--ts|--js]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--js"}
    
    if [[ "$project_type" == "--ts" ]]; then
        npx create-react-app "$project_name" --template typescript
    else
        npx create-react-app "$project_name"
    fi
    
    cd "$project_name" || return
    echo "React app '$project_name' created successfully!"
}

new-next-app() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-next-app <project-name> [--ts|--js]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--js"}
    
    if [[ "$project_type" == "--ts" ]]; then
        npx create-next-app "$project_name" --typescript
    else
        npx create-next-app "$project_name"
    fi
    
    cd "$project_name" || return
    echo "Next.js app '$project_name' created successfully!"
}

new-vue-app() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-vue-app <project-name> [--ts|--js]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--js"}
    
    if [[ "$project_type" == "--ts" ]]; then
        npx @vue/cli create "$project_name" --preset ts
    else
        npx @vue/cli create "$project_name"
    fi
    
    cd "$project_name" || return
    echo "Vue.js app '$project_name' created successfully!"
}

new-vite-app() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-vite-app <project-name> [--react|--vue|--svelte] [--ts|--js]"
        return 1
    fi
    
    local project_name=$1
    local framework=${2:-"--react"}
    local language=${3:-"--js"}
    
    local template=""
    
    case "$framework" in
        --react)
            if [[ "$language" == "--ts" ]]; then
                template="react-ts"
            else
                template="react"
            fi
            ;;
        --vue)
            if [[ "$language" == "--ts" ]]; then
                template="vue-ts"
            else
                template="vue"
            fi
            ;;
        --svelte)
            if [[ "$language" == "--ts" ]]; then
                template="svelte-ts"
            else
                template="svelte"
            fi
            ;;
        *)
            echo "Unknown framework: $framework"
            return 1
            ;;
    esac
    
    npx create-vite "$project_name" --template "$template"
    
    cd "$project_name" || return
    npm install
    
    echo "Vite app '$project_name' created successfully with $template template!"
}
