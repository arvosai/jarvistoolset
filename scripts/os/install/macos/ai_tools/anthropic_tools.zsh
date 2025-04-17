#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Anthropic Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure pip is up to date
execute "pip3 install --upgrade pip" \
    "Upgrading pip to latest version"

# Core Anthropic SDK and Client
execute "pip3 install anthropic" \
    "Installing Anthropic Python SDK"

# Constitutional AI Tools
execute "pip3 install anthropic-bedrock" \
    "Installing Anthropic Bedrock"

execute "pip3 install anthropic-tools" \
    "Installing Anthropic Tools"

# Machine Control Protocol (MCP)
execute "pip3 install anthropic-mcp" \
    "Installing Anthropic MCP Core"

execute "pip3 install anthropic-mcp-client" \
    "Installing Anthropic MCP Client"

execute "pip3 install anthropic-mcp-server" \
    "Installing Anthropic MCP Server"

execute "pip3 install anthropic-mcp-tools" \
    "Installing Anthropic MCP Tools"

execute "pip3 install anthropic-mcp-monitor" \
    "Installing Anthropic MCP Monitor"

execute "pip3 install anthropic-mcp-debug" \
    "Installing Anthropic MCP Debug Tools"

execute "pip3 install anthropic-mcp-security" \
    "Installing Anthropic MCP Security"

execute "pip3 install anthropic-mcp-validator" \
    "Installing Anthropic MCP Validator"

# MCP Extensions and Plugins
execute "pip3 install anthropic-mcp-extensions" \
    "Installing Anthropic MCP Extensions"

execute "pip3 install anthropic-mcp-plugins" \
    "Installing Anthropic MCP Plugins"

execute "pip3 install anthropic-mcp-dashboard" \
    "Installing Anthropic MCP Dashboard"

# Claude Integration
execute "pip3 install claude-api" \
    "Installing Claude API"

execute "pip3 install claude-client" \
    "Installing Claude Client"

# Prompt Engineering Tools
execute "pip3 install constitutional-ai" \
    "Installing Constitutional AI"

execute "pip3 install anthropic-prompt-toolkit" \
    "Installing Anthropic Prompt Toolkit"

# Development Tools
execute "pip3 install anthropic-tokenizer" \
    "Installing Anthropic Tokenizer"

execute "pip3 install anthropic-eval" \
    "Installing Anthropic Evaluation Tools"

# Integration Tools
execute "pip3 install langchain-anthropic" \
    "Installing LangChain Anthropic Integration"

execute "pip3 install anthropic-functions" \
    "Installing Anthropic Functions"

# Safety and Monitoring
execute "pip3 install anthropic-safety" \
    "Installing Anthropic Safety Tools"

execute "pip3 install anthropic-monitor" \
    "Installing Anthropic Monitoring"

# Utilities
execute "pip3 install anthropic-ratelimit" \
    "Installing Anthropic Rate Limiter"

execute "pip3 install anthropic-cache" \
    "Installing Anthropic Cache"

# Web Tools
execute "pip3 install anthropic-proxy" \
    "Installing Anthropic Proxy"

execute "pip3 install anthropic-webhook" \
    "Installing Anthropic Webhook"

# Authentication and Security
execute "pip3 install anthropic-auth" \
    "Installing Anthropic Auth"

execute "pip3 install anthropic-vault" \
    "Installing Anthropic Vault"

# Create configuration file for Anthropic
mkdir -p "$HOME/.jarvistoolset/zsh_configs"
cp "$SCRIPT_DIR/../../../../zsh_configs/anthropic.zsh" "$HOME/.jarvistoolset/zsh_configs/" 2>/dev/null || true

# Print setup instructions
print_in_green "
   Anthropic Tools Installation Complete!

"
print_in_yellow "   To configure your Anthropic API key, add the following to your environment:
"
print_in_yellow "   export ANTHROPIC_API_KEY='your-api-key'

"
print_in_yellow "   To start using MCP Server, run:
"
print_in_yellow "   mcp-start

"
