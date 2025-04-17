#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../../utils.zsh"
source "${SCRIPT_DIR}/../../utils.zsh" 2>/dev/null || true  # Source local utils if available

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && source "../../utils.zsh" \
    && source "./utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Docker

"

# Install Docker Desktop for Mac
print_info "Installing Docker Desktop for Mac..."
brew_install "Docker Desktop" "docker" "--cask"

# Create modular configuration file for Docker
create_docker_config() {
    local config_dir="$HOME/.jarvistoolset/zsh_configs"
    local config_file="$config_dir/docker.zsh"
    
    # Create directory if it doesn't exist
    mkdir -p "$config_dir"
    
    # Create Docker configuration file
    cat > "$config_file" << 'EOL'
#!/bin/zsh
#
# Docker configuration for zsh
# This file contains all Docker-related configurations
#

# Docker aliases
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias drmi="docker rmi"
alias drm="docker rm"
alias dexec="docker exec -it"
alias dlogs="docker logs -f"
alias dprune="docker system prune -af"
alias dstop="docker stop"
alias dstart="docker start"
alias drestart="docker restart"
alias dbuild="docker build -t"
alias drun="docker run -it"
alias dnetwork="docker network"
alias dvolume="docker volume"

# Docker Compose aliases
alias dcup="docker-compose up"
alias dcupd="docker-compose up -d"
alias dcdown="docker-compose down"
alias dcps="docker-compose ps"
alias dcrestart="docker-compose restart"
alias dcbuild="docker-compose build"
alias dclogs="docker-compose logs -f"
alias dcpull="docker-compose pull"

# Docker functions
docker-clean() {
    echo "Removing all stopped containers..."
    docker rm $(docker ps -a -q) 2>/dev/null || echo "No containers to remove"
    
    echo "Removing all dangling images..."
    docker rmi $(docker images -f "dangling=true" -q) 2>/dev/null || echo "No images to remove"
    
    echo "Removing all unused networks..."
    docker network prune -f 2>/dev/null || echo "No networks to remove"
    
    echo "Removing all unused volumes..."
    docker volume prune -f 2>/dev/null || echo "No volumes to remove"
    
    echo "Docker cleanup complete!"
}

docker-killall() {
    echo "Stopping all running containers..."
    docker stop $(docker ps -q) 2>/dev/null || echo "No running containers to stop"
}

docker-stats() {
    docker stats --format "table {{.Name}}	{{.CPUPerc}}	{{.MemUsage}}	{{.NetIO}}	{{.BlockIO}}"
}

# Docker project creation function
new-docker-project() {
    if [ $# -lt 1 ]; then
        echo "Usage: new-docker-project <project-name> [--node|--python|--go|--java]"
        return 1
    fi
    
    local project_name=$1
    local project_type=${2:-"--node"}
    
    # Create project directory
    mkdir -p "$project_name"
    cd "$project_name" || return
    
    # Create basic structure
    mkdir -p src
    
    # Create Dockerfile based on project type
    case "$project_type" in
        --node)
            cat > "Dockerfile" << EOF
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
            
            # Create package.json
            cat > "package.json" << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "description": "A Node.js application with Docker",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF
            
            # Create index.js
            mkdir -p src
            cat > "src/index.js" << EOF
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello from Docker!');
});

app.listen(port, () => {
  console.log(\`Server running at http://localhost:\${port}/\`);
});
EOF
            ;;
            
        --python)
            cat > "Dockerfile" << EOF
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "src/app.py"]
EOF
            
            # Create requirements.txt
            cat > "requirements.txt" << EOF
flask==2.3.3
gunicorn==21.2.0
EOF
            
            # Create app.py
            mkdir -p src
            cat > "src/app.py" << EOF
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from Docker!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF
            ;;
            
        --go)
            cat > "Dockerfile" << EOF
FROM golang:1.21-alpine AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o /app/server src/main.go

FROM alpine:latest

WORKDIR /app

COPY --from=build /app/server /app/server

EXPOSE 8080

CMD ["/app/server"]
EOF
            
            # Create go.mod
            cat > "go.mod" << EOF
module github.com/$(whoami)/$project_name

go 1.21
EOF
            
            # Create go.sum
            touch go.sum
            
            # Create main.go
            mkdir -p src
            cat > "src/main.go" << EOF
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from Docker!")
	})

	fmt.Println("Server starting at :8080")
	http.ListenAndServe(":8080", nil)
}
EOF
            ;;
            
        --java)
            cat > "Dockerfile" << EOF
FROM maven:3.9-eclipse-temurin-21-alpine AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
EOF
            
            # Create pom.xml
            cat > "pom.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>$project_name</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- Add your dependencies here -->
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>3.3.0</version>
                <configuration>
                    <archive>
                        <manifest>
                            <addClasspath>true</addClasspath>
                            <mainClass>com.example.App</mainClass>
                        </manifest>
                    </archive>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF
            
            # Create App.java
            mkdir -p src/main/java/com/example
            cat > "src/main/java/com/example/App.java" << EOF
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Docker!");
    }
}
EOF
            ;;
    esac
    
    # Create docker-compose.yml
    cat > "docker-compose.yml" << EOF
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - .:/app
    environment:
      - NODE_ENV=development
EOF
    
    # Create .dockerignore
    cat > ".dockerignore" << EOF
node_modules
npm-debug.log
Dockerfile
.dockerignore
.git
.gitignore
README.md
docker-compose.yml
EOF
    
    # Create README.md
    cat > "README.md" << EOF
# $project_name

A Docker project.

## Building

\`\`\`bash
docker build -t $project_name .
\`\`\`

## Running

\`\`\`bash
docker run -p 8080:8080 $project_name
\`\`\`

## Using Docker Compose

\`\`\`bash
docker-compose up
\`\`\`
EOF
    
    # Create .gitignore
    cat > ".gitignore" << EOF
# Docker
.docker/
docker-compose.override.yml

# Node.js
node_modules/
npm-debug.log

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
*.egg-info/
.installed.cfg
*.egg

# Go
*.exe
*.exe~
*.dll
*.so
*.dylib
*.test
*.out
vendor/

# Java
*.class
*.jar
*.war
*.ear
*.logs
*.iml
.idea/
.gradle/
build/
target/

# OS specific
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF
    
    # Initialize git repository if git is available
    if command -v git >/dev/null 2>&1; then
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    echo "Docker project '$project_name' created successfully!"
}
EOL
    
    print_result $? "Created Docker configuration file"
}

# Create modular configuration
create_docker_config

# Check if oh-my-zsh.zsh is already sourcing the modular configs
if ! grep -q "source \"\$HOME/.jarvistoolset/zsh_configs/docker.zsh\"" "$HOME/.zshrc"; then
    # Add a line to source the Docker config in .zshrc if oh-my-zsh.zsh isn't handling it
    cat >> "$HOME/.zshrc" << 'EOL'
# Load Docker configuration
source "$HOME/.jarvistoolset/zsh_configs/docker.zsh"
EOL
    print_result $? "Added Docker configuration to .zshrc"
fi

print_in_green "
  Docker setup complete!
"
