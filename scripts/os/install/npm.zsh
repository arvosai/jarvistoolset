#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../utils.zsh"

USERNAME="$1"

install_npm_package() {

    execute \
        ". $HOME/.zshrc \
            && npm install --global $1" \
        "$2"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures npm tools"  (npm)  (npm)


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Create a banner for this installation script
create_install_banner "$0"


main() {

    local USERNAME="$1"

    print_in_purple "
   npm

"

    # Check if Node.js is installed
    if ! cmd_exists "node"; then
        print_error "Node.js is required, please install it first."
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install packages
    
    install_npm_package "npm" "npm (update)"
    install_npm_package "typescript" "TypeScript"
    install_npm_package "eslint" "ESLint"
    install_npm_package "prettier" "Prettier"
    install_npm_package "serve" "Serve"
    install_npm_package "http-server" "HTTP Server"
    install_npm_package "nodemon" "Nodemon"
    install_npm_package "npm-check-updates" "npm-check-updates"
    install_npm_package "ts-node" "ts-node"
    install_npm_package "jest" "Jest"
    install_npm_package "create-react-app" "Create React App"
    install_npm_package "create-next-app" "Create Next App"
    install_npm_package "vercel" "Vercel CLI"
    install_npm_package "netlify-cli" "Netlify CLI"
    install_npm_package "firebase-tools" "Firebase Tools"
    install_npm_package "aws-cdk" "AWS CDK"
    install_npm_package "serverless" "Serverless Framework"
    install_npm_package "@angular/cli" "Angular CLI"
    install_npm_package "@vue/cli" "Vue CLI"
    install_npm_package "gatsby-cli" "Gatsby CLI"
    install_npm_package "svelte" "Svelte"
    install_npm_package "parcel-bundler" "Parcel Bundler"
    install_npm_package "webpack" "Webpack"
    install_npm_package "rollup" "Rollup"
    install_npm_package "esbuild" "esbuild"
    install_npm_package "vite" "Vite"
    install_npm_package "pm2" "PM2"
    install_npm_package "forever" "Forever"
    install_npm_package "concurrently" "Concurrently"
    install_npm_package "lerna" "Lerna"
    install_npm_package "nx" "Nx"
    install_npm_package "turbo" "Turborepo"
    install_npm_package "pnpm" "pnpm"
    install_npm_package "yarn" "Yarn"
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Use npm_install function for future installations
    
    # Example:
    # npm_install "TypeScript" "typescript"
    # npm_install "ESLint" "eslint"

}

main "$USERNAME"
