#!/usr/bin/env zsh
# Prevent function definitions from being printed
set +x

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
JARVIS_DIR="$HOME/.jarvistoolset"

# Define paths to scripts
UTILS_SCRIPT="${JARVIS_DIR}/scripts/os/utils.zsh"
MACOS_UTILS_SCRIPT="${JARVIS_DIR}/scripts/os/install/macos/utils.zsh"
LOGGING_SCRIPT="${JARVIS_DIR}/scripts/os/logging.zsh"

# Define the logs directory
LOGS_DIR="$HOME/.jarvistoolset/logs"

# Ensure logs directory exists
mkdir -p "$LOGS_DIR" 2>/dev/null

# Define print utility functions first (these don't depend on logging)
print_in_yellow() {
    printf "\e[0;33m%s\e[0m" "$1"
}

print_in_green() {
    printf "\e[0;32m%s\e[0m" "$1"
}

print_in_red() {
    printf "\e[0;31m%s\e[0m" "$1"
}

print_error() {
    print_in_red "✗ $1\n"
}

print_success() {
    print_in_green "✓ $1\n"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"
}

# Source scripts silently
source_script() {
    local script_path="$1"
    if [[ -f "$script_path" ]]; then
        source "$script_path" >/dev/null 2>&1
        return 0
    fi
    return 1
}

# Source the logging script first if it exists
source_script "$LOGGING_SCRIPT"

# Source utility scripts if they exist
source_script "$UTILS_SCRIPT"
source_script "$MACOS_UTILS_SCRIPT"

# Define fallback logging functions if they don't exist
if ! type log_info >/dev/null 2>&1; then
    # Global variables for logging
    CURRENT_LOG_FILE=""

    # Initialize logging
    init_logging() {
        # Create timestamp in format YYYY-MM-DD-HHMMSS
        local timestamp=$(date "+%Y-%m-%d-%H%M%S")
        
        # Create log filename
        CURRENT_LOG_FILE="${LOGS_DIR}/jarvistoolset-${timestamp}.log"
        
        # Ensure logs directory exists again (double-check)
        mkdir -p "$(dirname "$CURRENT_LOG_FILE")" 2>/dev/null
        
        # Create empty log file
        touch "$CURRENT_LOG_FILE"
        
        # Print log file location
        echo -e "\n >> Logging initialized\n\n   Log file: $CURRENT_LOG_FILE\n"
        
        # Add header to log file
        {
            echo "========================================================"
            echo "  JARVIS TOOLSET INSTALLATION LOG"
            echo "  Started: $(date)"
            echo "  Hostname: $(hostname)"
            echo "  User: $(whoami)"
            echo "========================================================"
            echo ""
        } >> "$CURRENT_LOG_FILE"
    }

    # Log a message to the log file
    log_message() {
        local message="$1"
        local level="${2:-INFO}"
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        
        # Initialize logging if not already done
        if [[ -z "$CURRENT_LOG_FILE" || ! -f "$CURRENT_LOG_FILE" ]]; then
            init_logging
        fi
        
        # Ensure logs directory exists again (triple-check)
        if [[ ! -d "$(dirname "$CURRENT_LOG_FILE")" ]]; then
            mkdir -p "$(dirname "$CURRENT_LOG_FILE")" 2>/dev/null
        fi
        
        echo "[${timestamp}] [${level}] ${message}" >> "$CURRENT_LOG_FILE"
    }

    log_info() {
        log_message "$1" "INFO"
    }

    log_warning() {
        log_message "$1" "WARNING"
    }

    log_error() {
        log_message "$1" "ERROR"
    }

    log_success() {
        log_message "$1" "SUCCESS"
    }

    log_command() {
        local command="$1"
        local description="${2:-$command}"
        log_info "Executing: $description"
        local output
        if output=$(eval "$command" 2>&1); then
            log_success "Command succeeded: $description"
            if [[ -n "$output" ]]; then
                {
                    echo "--- Command output start ---"
                    echo "$output"
                    echo "--- Command output end ---"
                    echo ""
                } >> "$CURRENT_LOG_FILE"
            fi
            return 0
        else
            local exit_code=$?
            log_error "Command failed (exit code $exit_code): $description"
            if [[ -n "$output" ]]; then
                {
                    echo "--- Command output start ---"
                    echo "$output"
                    echo "--- Command output end ---"
                    echo ""
                } >> "$CURRENT_LOG_FILE"
            fi
            return $exit_code
        fi
    }

    execute_with_log() {
        local cmd="$1"
        local msg="${2:-$1}"
        print_in_yellow "   $msg..."
        log_command "$cmd" "$msg"
        local exit_code=$?
        print_result $exit_code "$msg"
        return $exit_code
    }

    finalize_logging() {
        if [[ -n "$CURRENT_LOG_FILE" && -f "$CURRENT_LOG_FILE" ]]; then
            {
                echo ""
                echo "========================================================"
                echo "  JARVIS TOOLSET INSTALLATION COMPLETED"
                echo "  Finished: $(date)"
                echo "========================================================"
            } >> "$CURRENT_LOG_FILE"
        fi
    }
    
    # If log_system_info doesn't exist, define a simple version
    if ! type log_system_info >/dev/null 2>&1; then
        log_system_info() {
            log_info "System: $(uname -a)"
            log_info "User: $(whoami)"
            log_info "Hostname: $(hostname)"
        }
    fi
fi

# Initialize logging
init_logging

# Log system information
log_system_info

# Log start of Jarvis Toolset (silently)
log_info "Starting Jarvis Toolset"

# Check if the first argument is "/help"
if [[ "$1" == "/help" ]]; then
    # Path to README.md - using absolute path to avoid directory resolution issues
    README_PATH="${JARVIS_DIR}/README.md"
    
    # Verify README.md exists at the specified path
    if [[ ! -f "$README_PATH" ]]; then
        print_error "README.md not found at $README_PATH"
        log_error "README.md not found at $README_PATH"
        
        # Finalize logging
        finalize_logging
        
        exit 1
    fi
    
    # Check if glow is installed and install it if needed
    if ! command -v "glow" &>/dev/null; then
        # Only show error messages, not status updates
        log_info "Installing glow for displaying markdown files"
        
        # Check if Homebrew is installed, install it if needed
        if ! command -v "brew" &>/dev/null; then
            log_info "Homebrew is not installed. Installing Homebrew first"
            execute_with_log "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" "Installing Homebrew"
        fi
        
        # Install glow
        execute_with_log "brew install glow" "Installing Glow Markdown Viewer"
    fi
    
    # Display README.md using glow
    log_info "Displaying README.md with glow"
    glow -p "$README_PATH"
    
    # Finalize logging
    finalize_logging
    
    exit 0
fi

# Default values for user information
HOSTNAME=${1:-$(hostname)}
USERNAME=${2:-$(whoami)}
EMAIL=${3:-"evandro.reis@arvos.ai"}
DIRECTORY=${4:-"$HOME/.jarvistoolset"}

# Log configuration (silently)
log_info "Configuration:"
log_info "  Hostname: $HOSTNAME"
log_info "  Username: $USERNAME"
log_info "  Email: $EMAIL"
log_info "  Directory: $DIRECTORY"


# Path to the setup script
SETUP_SCRIPT="${JARVIS_DIR}/scripts/os/setup.zsh"

# Check if the setup script exists
if [[ ! -f "$SETUP_SCRIPT" ]]; then
    print_error "Setup script not found at $SETUP_SCRIPT"
    log_error "Setup script not found at $SETUP_SCRIPT"
    
    # Finalize logging
    finalize_logging
    
    exit 1
fi

# Export SUDO_REQUESTED variable to ensure it's available in all child processes
export SUDO_REQUESTED=false
log_info "Set SUDO_REQUESTED=false"

# Copy utils.zsh to the same directory as setup.zsh if it doesn't exist there
SETUP_DIR="$(dirname "$SETUP_SCRIPT")"
if [[ ! -f "${SETUP_DIR}/utils.zsh" ]]; then
    if [[ -f "$UTILS_SCRIPT" ]]; then
        if type execute_with_log &>/dev/null; then
            execute_with_log "cp \"$UTILS_SCRIPT\" \"${SETUP_DIR}/utils.zsh\"" "Copying utils.zsh to ${SETUP_DIR}"
        else
            cp "$UTILS_SCRIPT" "${SETUP_DIR}/utils.zsh" >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                print_error "Failed to copy utils.zsh to ${SETUP_DIR}"
                log_error "Failed to copy utils.zsh to ${SETUP_DIR}"
            fi
        fi
    fi
fi

# Change to the setup script directory before executing it
# This ensures relative paths in setup.zsh work correctly
log_info "Changing to directory: $SETUP_DIR"
if ! cd "$SETUP_DIR" 2>/dev/null; then
    print_error "Failed to change to directory: $SETUP_DIR"
    log_error "Failed to change to directory: $SETUP_DIR"
    
    # Finalize logging
    finalize_logging
    
    exit 1
fi

# Log execution of setup script
log_info "Executing setup script: $SETUP_SCRIPT"
# echo "Starting Jarvis Toolset setup..."

# Call the setup script with the arguments
"$SETUP_SCRIPT" "$HOSTNAME" "$USERNAME" "$EMAIL" "$DIRECTORY"

# Capture the exit code
EXIT_CODE=$?

# Log the result of the setup script execution
if [ $EXIT_CODE -eq 0 ]; then
    log_success "Setup script completed successfully"
    echo "Jarvis Toolset setup completed successfully!"
else
    log_error "Setup script failed with exit code $EXIT_CODE"
    print_error "Jarvis Toolset setup failed with exit code $EXIT_CODE"
fi

# Finalize logging
log_info "Finalizing logging"
finalize_logging

exit $EXIT_CODE
