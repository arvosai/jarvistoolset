#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Vercel Development Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Vercel Platform
execute "npm install -g vercel" \
    "Installing Vercel CLI"

execute "npm install -g @vercel/node" \
    "Installing Vercel Node Runtime"

execute "npm install -g @vercel/python" \
    "Installing Vercel Python Runtime"

execute "npm install -g @vercel/go" \
    "Installing Vercel Go Runtime"

execute "npm install -g @vercel/ruby" \
    "Installing Vercel Ruby Runtime"

execute "npm install -g @vercel/static" \
    "Installing Vercel Static Runtime"

# Vercel Frameworks
execute "npm install -g next" \
    "Installing Next.js"

execute "npm install -g create-next-app" \
    "Installing Create Next App"

execute "npm install -g @vercel/remix" \
    "Installing Vercel Remix"

execute "npm install -g svelte" \
    "Installing Svelte"

execute "npm install -g @vercel/redwood" \
    "Installing Vercel RedwoodJS"

execute "npm install -g @vercel/blitz" \
    "Installing Vercel BlitzJS"

# Vercel Edge Functions
execute "npm install -g @vercel/edge" \
    "Installing Vercel Edge"

execute "npm install -g @vercel/edge-functions" \
    "Installing Vercel Edge Functions"

execute "npm install -g @vercel/edge-config" \
    "Installing Vercel Edge Config"

execute "npm install -g @vercel/edge-middleware" \
    "Installing Vercel Edge Middleware"

# Vercel Storage
execute "npm install -g @vercel/postgres" \
    "Installing Vercel Postgres"

execute "npm install -g @vercel/kv" \
    "Installing Vercel KV"

execute "npm install -g @vercel/blob" \
    "Installing Vercel Blob Storage"

execute "npm install -g @vercel/cache" \
    "Installing Vercel Cache"

# Vercel Analytics
execute "npm install -g @vercel/analytics" \
    "Installing Vercel Analytics"

execute "npm install -g @vercel/speed-insights" \
    "Installing Vercel Speed Insights"

execute "npm install -g @vercel/web-analytics" \
    "Installing Vercel Web Analytics"

execute "npm install -g @vercel/performance" \
    "Installing Vercel Performance"

# Vercel Development Tools
execute "npm install -g turbo" \
    "Installing Turborepo"

execute "npm install -g @vercel/style-guide" \
    "Installing Vercel Style Guide"

execute "npm install -g @vercel/git-hooks" \
    "Installing Vercel Git Hooks"

execute "npm install -g @vercel/build-utils" \
    "Installing Vercel Build Utils"

# Vercel Backend Tools
execute "npm install -g @vercel/node-server" \
    "Installing Vercel Node Server"

execute "npm install -g @vercel/python-server" \
    "Installing Vercel Python Server"

execute "npm install -g @vercel/go-server" \
    "Installing Vercel Go Server"

execute "npm install -g @vercel/api" \
    "Installing Vercel API"

# Vercel Database Tools
execute "npm install -g @vercel/postgres-client" \
    "Installing Vercel Postgres Client"

execute "npm install -g @vercel/mongo" \
    "Installing Vercel MongoDB"

execute "npm install -g @vercel/redis" \
    "Installing Vercel Redis"

execute "npm install -g prisma" \
    "Installing Prisma"

# Vercel UI Components
execute "npm install -g @vercel/ui" \
    "Installing Vercel UI"

execute "npm install -g @vercel/examples" \
    "Installing Vercel Examples"

execute "npm install -g @vercel/themes" \
    "Installing Vercel Themes"

# Vercel AI Tools
execute "npm install -g @vercel/ai" \
    "Installing Vercel AI SDK"

execute "npm install -g @vercel/ai-utils" \
    "Installing Vercel AI Utils"

execute "npm install -g @vercel/ai-models" \
    "Installing Vercel AI Models"

# Vercel Security
execute "npm install -g @vercel/security" \
    "Installing Vercel Security"

execute "npm install -g @vercel/protection" \
    "Installing Vercel Protection"

execute "npm install -g @vercel/auth" \
    "Installing Vercel Auth"

# Vercel Testing
execute "npm install -g @vercel/test" \
    "Installing Vercel Test"

execute "npm install -g @vercel/jest" \
    "Installing Vercel Jest"

execute "npm install -g @vercel/cypress" \
    "Installing Vercel Cypress"

# Vercel Monitoring
execute "npm install -g @vercel/monitoring" \
    "Installing Vercel Monitoring"

execute "npm install -g @vercel/logging" \
    "Installing Vercel Logging"

execute "npm install -g @vercel/error-handling" \
    "Installing Vercel Error Handling"

# Vercel CLI Tools
execute "npm install -g @vercel/cli-deploy" \
    "Installing Vercel Deploy CLI"

execute "npm install -g @vercel/cli-dev" \
    "Installing Vercel Dev CLI"

execute "npm install -g @vercel/cli-build" \
    "Installing Vercel Build CLI"
