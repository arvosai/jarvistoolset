#!/usr/bin/env zsh
# Prevent function definitions from being printed
set +x

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | User Input Functions                                                 |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read -r
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -r -k 1
    print
}

ask_for_sudo() {
    # Save sudo timestamp file location
    local sudo_timestamp_dir="/var/run/sudo/${USER}"
    local sudo_timestamp_file="${sudo_timestamp_dir}/ts"
    
    # Create a global variable to track if sudo has been requested
    SUDO_REQUESTED=true
    
    print_in_yellow "Please enter your password. It will be cached for all installation tasks.\n"
    
    # Log the sudo request
    if type log_info &>/dev/null; then
        log_info "Requesting sudo privileges"
    fi
    
    # Ask for the administrator password upfront
    sudo -v &> /dev/null
    
    # Create a timestamp directory for this user if it doesn't exist
    sudo mkdir -p "$sudo_timestamp_dir" 2>/dev/null
    sudo chmod 700 "$sudo_timestamp_dir" 2>/dev/null
    
    # Update existing `sudo` time stamp
    # until this script finishes
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

sudo_is_active() {
    if [ -n "${SUDO_REQUESTED:-}" ]; then
        # Refresh sudo timestamp without prompting for password
        sudo -n true 2>/dev/null
        return $?
    else
        # If sudo hasn't been requested yet, do it now
        ask_for_sudo
        return 0
    fi
}

sudo_execute() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    
    # Ensure sudo is active
    sudo_is_active
    
    # Execute the command with sudo
    execute "sudo $CMDS" "$MSG"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Command Execution Functions                                          |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmd_exists() {
    (( $+commands[$1] ))
}

execute_original() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # If the current process is ended,
    # also end all its subprocesses.
    set_trap "EXIT" "kill_all_subprocesses"

    # Check if this is a sudo command and ensure sudo is active
    if [[ "$CMDS" == sudo* ]]; then
        sudo_is_active
    fi

    # Execute commands in background
    # Ensure we're only executing the command, not the message
    ( eval "$CMDS" ) \
        &> /dev/null \
        2> "$TMP_FILE" &

    cmdsPID=$!

    # Show a spinner if the commands
    # require more time to complete.
    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # Wait for the commands to complete.
    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    return $exitCode
}

# Execute a command with logging
execute() {
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # If the current process is ended,
    # also end all its subprocesses.
    set_trap "EXIT" "kill_all_subprocesses"

    # Check if this is a sudo command and ensure sudo is active
    if [[ "$CMDS" == sudo* ]]; then
        sudo_is_active
    fi

    # Log the command execution
    if type log_info &>/dev/null; then
        log_info "Executing: $MSG"
    fi

    # Execute commands and capture output
    local output=""
    output=$(eval "$CMDS" 2>&1)
    exitCode=$?

    # Log the command output
    if type log_info &>/dev/null; then
        if [ $exitCode -eq 0 ]; then
            # Success is logged by print_result -> print_success
            if [[ -n "$output" ]]; then
                log_message "Command output: $output" "OUTPUT"
            fi
        else
            # Error is logged by print_result -> print_error
            if [[ -n "$output" ]]; then
                log_message "Command error output: $output" "ERROR_OUTPUT"
            fi
        fi
    fi

    # Print result
    print_result $exitCode "$MSG"
    
    # Show error output if command failed
    if [ $exitCode -ne 0 ] && [[ -n "$output" ]]; then
        print_error_stream <<< "$output"
    fi

    return $exitCode
}

kill_all_subprocesses() {
    local i=""

    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &> /dev/null
    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | System Information Functions                                         |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

get_os() {
    local os=""
    local kernelName=""

    kernelName="$(uname -s)"

    if [ "$kernelName" = "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" = "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os="ubuntu"
    else
        os="$kernelName"
    fi

    printf "%s" "$os"
}

get_os_version() {
    local os=""
    local version=""

    os="$(get_os)"

    if [ "$os" = "macos" ]; then
        version="$(sw_vers -productVersion)"
    elif [ "$os" = "ubuntu" ]; then
        version="$(lsb_release -d | cut -f2 | cut -d' ' -f2)"
    fi

    printf "%s" "$version"
}

is_supported_version() {
    declare -r MINIMUM_VERSION="$2"
    declare -r SUBJECT_VERSION="$1"

    if [ "${SUBJECT_VERSION}" = "${MINIMUM_VERSION}" ]; then
        return 0
    fi

    IFS='.' read -r -a minimum_version <<< "$MINIMUM_VERSION"
    IFS='.' read -r -a subject_version <<< "$SUBJECT_VERSION"

    if [ "${#minimum_version[@]}" -ne "${#subject_version[@]}" ]; then
        return 1
    fi

    for i in "${!minimum_version[@]}"; do
        if [ "${subject_version[i]}" -lt "${minimum_version[i]}" ]; then
            return 1
        elif [ "${subject_version[i]}" -gt "${minimum_version[i]}" ]; then
            return 0
        fi
    done

    return 0
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Package Management Functions                                         |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install() {
    declare -r FORMULA_READABLE_NAME="$1"
    declare -r FORMULA="$2"
    declare -r CMD="$3"

    if ! cmd_exists "brew"; then
        print_error "$FORMULA_READABLE_NAME ('brew' is not installed)"
        return 1
    fi

    if [ "$CMD" = "--cask" ]; then
        if brew list --cask "$FORMULA" &> /dev/null; then
            print_success "$FORMULA_READABLE_NAME"
        else
            execute "brew install --cask $FORMULA" "$FORMULA_READABLE_NAME"
        fi
    else
        if brew list "$FORMULA" &> /dev/null; then
            print_success "$FORMULA_READABLE_NAME"
    else
            execute "brew install $FORMULA" "$FORMULA_READABLE_NAME"
        fi
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | File System Functions                                                |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_directory() {
    local directory="${1}"
    
    if [[ ! -d "$directory" ]]; then
        execute "mkdir -p $directory" "Creating directory: $directory"
    else
        print_success "Directory exists: $directory"
    fi
}

extract() {
    local archive="$1"
    local outputDir="$2"

    if (( $+commands[tar] )); then
        tar -zxf "$archive" --strip-components 1 -C "$outputDir"
        return $?
    fi

    return 1
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Python Package Management Functions                                  |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pip_install() {
    local package="$1"
    local message="$2"
    execute "pip3 install $package" "$message"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Print Functions                                                      |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_green() {
    print_in_color "$1" 2
    # Log success message if log_success is available
    if type log_success &>/dev/null; then
        log_success "${1//\n/}"
    fi
}

print_in_purple() {
    print_in_color "$1" 5
    # Log info message if log_info is available
    if type log_info &>/dev/null; then
        log_info "${1//\n/}"
    fi
}

print_in_red() {
    print_in_color "$1 (See logs for details)" 1
    # Log error message if log_error is available
    if type log_error &>/dev/null; then
        log_error "${1//\n/}"
    fi
}

print_in_yellow() {
    print_in_color "$1" 3
    # Log info message if log_info is available
    if type log_info &>/dev/null; then
        log_info "${1//\n/}"
    fi
}

print_question() {
    print_in_yellow "   [?] $1"
    # Log question if log_info is available
    if type log_info &>/dev/null; then
        log_info "Question: $1"
    fi
}

print_error() {
    print_in_red "   [✗] $1 $2\n"
    # Log error if log_error is available
    if type log_error &>/dev/null; then
        log_error "$1 $2"
    fi
}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
        # Error stream is already logged by print_error
    done
}

print_success() {
    print_in_green "   [✓] $1\n"
    # Log success if log_success is available
    if type log_success &>/dev/null; then
        log_success "$1"
    fi
}

print_warning() {
    print_in_yellow "   [!] $1\n"
    # Log warning if log_warning is available
    if type log_warning &>/dev/null; then
        log_warning "$1"
    fi
}

print_info() {
    print_in_purple "   [i] $1\n"
    # Log info if log_info is available
    if type log_info &>/dev/null; then
        log_info "$1"
    fi
}

print_result() {
    if [ "$1" -eq 0 ]; then
        print_success "$2"
        # Success is already logged by print_success
    else
        print_error "$2"
        # Error is already logged by print_error
    fi
    
    return "$1"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# | Process Management Functions                                         |
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set_trap() {
    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"
}

show_spinner() {
    local -r FRAMES='/-\|'

    local -r NUMBER_OR_FRAMES=${#FRAMES}
    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local i=0
    local frameText=""

    # Display spinner while the commands are being executed.
    while kill -0 "$PID" &>/dev/null; do
        # Fix for zsh substring syntax
        local idx=$((i % NUMBER_OR_FRAMES))
        local frame=${FRAMES:$idx:1}
        frameText="   [$frame] $MSG"

        printf "%s" "$frameText"
        sleep 0.2
        printf "\r"
        ((i++))
    done
}
