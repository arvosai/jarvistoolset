#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Backend Development Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Programming Languages
execute "brew install python" \
    "Installing Python"

execute "brew install go" \
    "Installing Go"

execute "brew install rust" \
    "Installing Rust"

execute "brew install java" \
    "Installing Java"

# Web Frameworks
execute "pip3 install flask" \
    "Installing Flask"

execute "pip3 install django" \
    "Installing Django"

execute "pip3 install fastapi" \
    "Installing FastAPI"

execute "pip3 install uvicorn" \
    "Installing Uvicorn"

# Database Tools
execute "brew install postgresql" \
    "Installing PostgreSQL"

execute "brew install mysql" \
    "Installing MySQL"

execute "brew install mongodb-community" \
    "Installing MongoDB"

execute "brew install redis" \
    "Installing Redis"

# API Development
execute "pip3 install requests" \
    "Installing Requests"

execute "pip3 install httpx" \
    "Installing HTTPX"

execute "pip3 install graphene" \
    "Installing Graphene"

# Message Brokers
execute "brew install rabbitmq" \
    "Installing RabbitMQ"

execute "brew install kafka" \
    "Installing Kafka"

execute "brew install celery" \
    "Installing Celery"

# Containerization
execute "brew install docker" \
    "Installing Docker"

execute "brew install kubectl" \
    "Installing Kubectl"

execute "brew install minikube" \
    "Installing Minikube"

# Development Tools
execute "pip3 install pytest" \
    "Installing PyTest"

execute "pip3 install black" \
    "Installing Black"

execute "pip3 install mypy" \
    "Installing MyPy"

# Monitoring Tools
execute "pip3 install prometheus-client" \
    "Installing Prometheus Client"

execute "pip3 install grafana" \
    "Installing Grafana"

execute "pip3 install datadog" \
    "Installing Datadog"

# Security Tools
execute "pip3 install bandit" \
    "Installing Bandit"

execute "pip3 install safety" \
    "Installing Safety"

execute "pip3 install owasp-zap" \
    "Installing OWASP ZAP"

# Documentation
execute "pip3 install sphinx" \
    "Installing Sphinx"

execute "pip3 install mkdocs" \
    "Installing MkDocs"

execute "pip3 install swagger-ui" \
    "Installing Swagger UI"

# Load Testing
execute "pip3 install locust" \
    "Installing Locust"

execute "pip3 install apache-bench" \
    "Installing Apache Bench"

execute "pip3 install wrk" \
    "Installing WRK"
