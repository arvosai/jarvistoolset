#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../../../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Node.js\n\n"

# Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
    print_info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    
    # Load NVM immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    print_result $? "NVM installation"
else
    print_success "NVM is already installed"
    
    # Ensure NVM is loaded even if it was already installed
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Create modular configuration file for Node.js
create_node_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/node.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Node.js configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Node.js configuration for zsh
# This file contains all Node.js-related configurations
#

# NVM (Node Version Manager) setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Node.js aliases
alias npm-update="npm update -g"
alias npm-list="npm list -g --depth=0"
alias yarn-update="yarn global upgrade"
alias yarn-list="yarn global list"

# Node.js project creation function
new-node() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-node <project-name> [template]"
        echo "Available templates: basic, express, typescript"
        return 1
    fi
    
    local project_name=$1
    local template=${2:-"basic"}
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Initialize npm
    npm init -y
    
    # Update package.json with better defaults
    node -e "
        const fs = require('fs');
        const pkg = JSON.parse(fs.readFileSync('./package.json'));
        pkg.description = '${project_name} project';
        pkg.author = '$(git config user.name) <$(git config user.email)>';
        pkg.license = 'MIT';
        pkg.scripts = pkg.scripts || {};
        pkg.scripts.start = 'node index.js';
        pkg.scripts.test = 'echo \"Error: no test specified\" && exit 1';
        fs.writeFileSync('./package.json', JSON.stringify(pkg, null, 2));
    "
    
    # Create basic files based on template
    case "$template" in
        "express")
            # Install Express dependencies
            npm install express body-parser cors
            npm install --save-dev nodemon
            
            # Update scripts in package.json
            node -e "
                const fs = require('fs');
                const pkg = JSON.parse(fs.readFileSync('./package.json'));
                pkg.scripts.start = 'node app.js';
                pkg.scripts.dev = 'nodemon app.js';
                fs.writeFileSync('./package.json', JSON.stringify(pkg, null, 2));
            "
            
            # Create Express app.js
            cat > app.js << EOF
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Routes
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to ${project_name} API' });
});

// Start server
app.listen(PORT, () => {
  console.log(\`Server is running on port \${PORT}\`);
});
EOF
            ;;
            
        "typescript")
            # Install TypeScript dependencies
            npm install --save-dev typescript ts-node @types/node
            
            # Update scripts in package.json
            node -e "
                const fs = require('fs');
                const pkg = JSON.parse(fs.readFileSync('./package.json'));
                pkg.scripts.start = 'node dist/index.js';
                pkg.scripts.build = 'tsc';
                pkg.scripts.dev = 'ts-node src/index.ts';
                fs.writeFileSync('./package.json', JSON.stringify(pkg, null, 2));
            "
            
            # Create tsconfig.json
            cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "es2018",
    "module": "commonjs",
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
            
            # Create src directory and index.ts
            mkdir -p src
            cat > src/index.ts << EOF
/**
 * ${project_name} - TypeScript project
 */

function greet(name: string): string {
  return \`Hello, \${name}!\`;
}

console.log(greet('${project_name}'));

export { greet };
EOF
            ;;
            
        *)  # basic template
            # Create index.js
            cat > index.js << EOF
/**
 * ${project_name} - Node.js project
 */

console.log('Hello, ${project_name}!');
EOF
            ;;
    esac
    
    # Create .gitignore
    cat > .gitignore << EOF
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Dependency directories
node_modules/

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Output of 'npm pack'
*.tgz

# dotenv environment variables file
.env

# Build output
dist/
build/
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Node.js project '${project_name}' created successfully with '${template}' template!"
}
EOL
    
    print_result $? "Created Node.js configuration file"
}

# Install Node.js LTS version
print_info "Installing Node.js LTS version..."

# Ensure NVM is available in this script
if ! command -v nvm &>/dev/null; then
    print_warning "NVM command not found, attempting to load NVM again..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    # Check again if NVM is available
    if ! command -v nvm &>/dev/null; then
        print_error "Failed to load NVM. Please restart your terminal and try again."
        exit 1
    fi
fi

# Now use NVM to install and use Node.js
nvm install --lts
nvm use --lts
print_result $? "Node.js LTS installation"

# Install global npm packages
print_in_purple "\n   Installing Global npm Packages\n\n"

npm_install() {
    declare -r PACKAGE="$1"
    declare -r PACKAGE_READABLE_NAME="$2"

    if npm list -g "$PACKAGE" &> /dev/null; then
        print_success "$PACKAGE_READABLE_NAME"
    else
        execute "npm install -g $PACKAGE" "$PACKAGE_READABLE_NAME"
    fi
}

npm_install "yarn" "Yarn"
npm_install "npm-check-updates" "npm-check-updates"
npm_install "typescript" "TypeScript"
npm_install "ts-node" "ts-node"
npm_install "eslint" "ESLint"
npm_install "prettier" "Prettier"
npm_install "nodemon" "Nodemon"
npm_install "serve" "Serve"
npm_install "http-server" "HTTP Server"
npm_install "json-server" "JSON Server"
npm_install "npm-why" "npm-why"
npm_install "npm-check" "npm-check"
npm_install "depcheck" "Depcheck"
npm_install "madge" "Madge"
# npm_install "npm-audit-fix-all" "npm-audit-fix-all" - Package no longer exists in npm registry
# Using npm's built-in audit fix capabilities instead (no package needed)

# Create modular configuration
create_node_config

print_in_green "\n  Node.js development environment setup complete!\n"
