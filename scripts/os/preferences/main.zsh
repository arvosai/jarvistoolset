#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures main tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list

# Default values
HOSTNAME="$1"
USERNAME="$2"
EMAIL="$3"

print_in_purple "
 >> Preferências...
"

"./$(get_os)/main.sh" "$HOSTNAME" "$USERNAME" "$EMAIL"
