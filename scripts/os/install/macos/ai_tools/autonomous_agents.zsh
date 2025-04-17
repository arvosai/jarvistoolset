#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Autonomous Agents Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# LangChain - Framework for developing context-aware reasoning applications
execute "pip3 install langchain" \
    "Installing LangChain"

# Auto-GPT - Autonomous GPT-4 experiment
execute "pip3 install auto-gpt" \
    "Installing Auto-GPT"

# Agent tooling and frameworks
execute "pip3 install crewai" \
    "Installing CrewAI"

execute "pip3 install autogen" \
    "Installing AutoGen"

# Vector databases for agent memory
execute "pip3 install chromadb" \
    "Installing ChromaDB"

execute "pip3 install faiss-cpu" \
    "Installing FAISS"

# Tools for agent capabilities
execute "pip3 install selenium" \
    "Installing Selenium for web automation"

execute "pip3 install beautifulsoup4" \
    "Installing BeautifulSoup for web scraping"

execute "pip3 install duckduckgo-search" \
    "Installing DuckDuckGo Search"

# Document processing
execute "pip3 install unstructured" \
    "Installing Unstructured"

execute "pip3 install pypdf" \
    "Installing PyPDF"

# Agent observation and monitoring
execute "pip3 install wandb" \
    "Installing Weights & Biases"

# Natural Language Processing
execute "pip3 install spacy" \
    "Installing SpaCy"

execute "python3 -m spacy download en_core_web_sm" \
    "Downloading SpaCy English model"
