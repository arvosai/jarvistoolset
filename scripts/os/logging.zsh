#!/usr/bin/env zsh
# Prevent function definitions from being printed
set +x

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh" >/dev/null 2>&1 || true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures logging tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


# Global variables
LOGS_DIR="$HOME/.jarvistoolset/logs"
CURRENT_LOG_FILE=""

# Initialize logging
init_logging() {
    # Create timestamp in format YYYY-MM-DD-HHMMSS
    local timestamp=$(date "+%Y-%m-%d-%H%M%S")
    
    # Ensure logs directory exists
    mkdir -p "$LOGS_DIR" 2>/dev/null
    
    # Create log filename
    CURRENT_LOG_FILE="${LOGS_DIR}/jarvistoolset-${timestamp}.log"
    
    # Create empty log file
    touch "$CURRENT_LOG_FILE"
    
    # Add header to log file (silently)
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
    
    # Check if log file exists
    if [[ -z "$CURRENT_LOG_FILE" || ! -f "$CURRENT_LOG_FILE" ]]; then
        init_logging
    fi
    
    # Write to log file
    echo "[${timestamp}] [${level}] ${message}" >> "$CURRENT_LOG_FILE"
}

# Log an info message
log_info() {
    log_message "$1" "INFO"
}

# Log a warning message
log_warning() {
    log_message "$1" "WARNING"
}

# Log an error message
log_error() {
    log_message "$1" "ERROR"
}

# Log a success message
log_success() {
    log_message "$1" "SUCCESS"
}

# Log a command execution
log_command() {
    local command="$1"
    local description="${2:-$command}"
    
    log_info "Executing: $description"
    
    # Execute the command and capture output
    local output
    if output=$(eval "$command" 2>&1); then
        log_success "Command succeeded: $description"
        # Log the output if there is any
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
        # Log the output if there is any
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

# Execute a command with logging
execute_with_log() {
    local cmd="$1"
    local msg="${2:-$1}"
    
    # Only show the command being executed if print_in_yellow exists
    if type print_in_yellow &>/dev/null; then
        print_in_yellow "   $msg...
"
    fi
    
    # Execute command and log it
    log_command "$cmd" "$msg"
    local exit_code=$?
    
    # Show the result if print_result exists
    if type print_result &>/dev/null; then
        print_result $exit_code "$msg"
    elif [ $exit_code -ne 0 ]; then
        # Only show errors if print_result doesn't exist
        echo -e "[31m✗ $msg[0m"
    fi
    
    return $exit_code
}

# Log system information
log_system_info() {
    {
        echo "========================================================"
        echo "  SYSTEM INFORMATION"
        echo "========================================================"
        echo "OS: $(uname -s)"
        echo "OS Version: $(sw_vers -productVersion 2>/dev/null || echo 'Unknown')"
        echo "Architecture: $(uname -m)"
        echo "Kernel: $(uname -r)"
        echo "Hostname: $(hostname)"
        echo "User: $(whoami)"
        echo "Shell: $SHELL"
        echo "Terminal: $TERM"
        echo "Home Directory: $HOME"
        echo "Current Directory: $(pwd)"
        echo "PATH: $PATH"
        echo ""
    } >> "$CURRENT_LOG_FILE"
}

# Finalize logging
finalize_logging() {
    if [[ -n "$CURRENT_LOG_FILE" && -f "$CURRENT_LOG_FILE" ]]; then
        {
            echo ""
            echo "========================================================"
            echo "  INSTALLATION COMPLETED"
            echo "  Finished: $(date)"
            echo "  Total Duration: $(($(date +%s) - $(date -r "$CURRENT_LOG_FILE" +%s))) seconds"
            echo "========================================================"
        } >> "$CURRENT_LOG_FILE"
        
        print_in_purple "
 >> Logging finalized

"
        print_in_yellow "   Log file: $CURRENT_LOG_FILE

"
    fi
}

# Don't export functions - this prevents them from being printed
# when the script is sourced
