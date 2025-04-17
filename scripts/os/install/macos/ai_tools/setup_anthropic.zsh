#!/bin/zsh
#
# Setup script for Anthropic MCP Servers and Clients
#

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Setting up Anthropic MCP Environment

"

# Create virtual environment for Anthropic tools
execute "python3 -m venv $HOME/.anthropic-env" \
    "Creating virtual environment for Anthropic tools"

# Activate the virtual environment
source "$HOME/.anthropic-env/bin/activate"

# Install Anthropic tools
source "${SCRIPT_DIR}/anthropic_tools.zsh"

# Create MCP configuration directory
execute "mkdir -p $HOME/.anthropic/mcp" \
    "Creating MCP configuration directory"

# Create default MCP configuration file
cat > "$HOME/.anthropic/mcp/config.json" << EOF
{
    "server": {
        "host": "localhost",
        "port": 8000,
        "log_level": "info",
        "workers": 4,
        "timeout": 60
    },
    "client": {
        "timeout": 60,
        "retry_count": 3,
        "log_level": "info"
    },
    "security": {
        "enable_auth": false,
        "auth_token": "",
        "ssl_enabled": false,
        "ssl_cert": "",
        "ssl_key": ""
    },
    "logging": {
        "log_file": "$HOME/.anthropic/mcp/logs/mcp.log",
        "log_level": "info",
        "log_format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    }
}
EOF

# Create logs directory
execute "mkdir -p $HOME/.anthropic/mcp/logs" \
    "Creating MCP logs directory"

# Create examples directory
execute "mkdir -p $HOME/.anthropic/mcp/examples" \
    "Creating MCP examples directory"

# Create example server script
cat > "$HOME/.anthropic/mcp/examples/server_example.py" << EOF
#!/usr/bin/env python3
"""
Example MCP Server implementation
"""
from anthropic_mcp_server import MCPServer
import json
import os

def main():
    # Load configuration
    config_path = os.path.expanduser("~/.anthropic/mcp/config.json")
    with open(config_path, 'r') as f:
        config = json.load(f)
    
    # Create and start server
    server = MCPServer(
        host=config['server']['host'],
        port=config['server']['port'],
        log_level=config['server']['log_level']
    )
    
    print(f"Starting MCP Server on {config['server']['host']}:{config['server']['port']}")
    server.start()

if __name__ == "__main__":
    main()
EOF

# Create example client script
cat > "$HOME/.anthropic/mcp/examples/client_example.py" << EOF
#!/usr/bin/env python3
"""
Example MCP Client implementation
"""
from anthropic_mcp_client import MCPClient
import json
import os

def main():
    # Load configuration
    config_path = os.path.expanduser("~/.anthropic/mcp/config.json")
    with open(config_path, 'r') as f:
        config = json.load(f)
    
    # Create client
    client = MCPClient(
        host=config['server']['host'],
        port=config['server']['port'],
        timeout=config['client']['timeout']
    )
    
    # Send a request
    request = {
        "message": "Hello, MCP!",
        "parameters": {
            "model": "claude-3-opus-20240229",
            "max_tokens": 1000
        }
    }
    
    print(f"Sending request to MCP Server at {config['server']['host']}:{config['server']['port']}")
    response = client.send_request(request)
    print(f"Response: {response}")

if __name__ == "__main__":
    main()
EOF

# Make example scripts executable
chmod +x "$HOME/.anthropic/mcp/examples/server_example.py"
chmod +x "$HOME/.anthropic/mcp/examples/client_example.py"

# Deactivate virtual environment
deactivate

print_in_green "
   Anthropic MCP Environment Setup Complete!

"
print_in_yellow "   To activate the Anthropic environment, run:
"
print_in_yellow "   source $HOME/.anthropic-env/bin/activate

"
print_in_yellow "   To start the MCP Server example, run:
"
print_in_yellow "   $HOME/.anthropic/mcp/examples/server_example.py

"
print_in_yellow "   To run the MCP Client example, run:
"
print_in_yellow "   $HOME/.anthropic/mcp/examples/client_example.py

"
