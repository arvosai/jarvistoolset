#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

DIRECTORY="$4"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create framed header with script details and tools list
create_framed_header "$0" "Installs and configures create_symbolic_links tools" No specific tools identified in script


# Create framed header with script details and tools list


# Create framed header with script details and tools list


create_symlinks() {
    # Declare files to symlink with zsh array syntax
    local -a FILES_TO_SYMLINK=(
        "shell/aliases/zsh_aliases"
        "shell/autocomplete/$(get_os)/zsh_autocomplete"
        "shell/zsh_exports"
        "shell/zsh_functions"
        "shell/zsh_logout"
        "shell/zsh_options"
        "shell/zshrc"
        "shell/zshenv"
        "shell/zprofile"
        "shell/inputrc"
        "git/gitattributes"
        "git/gitconfig"
        "git/gitignore"

    )

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=false

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${FILES_TO_SYMLINK[@]}"; do

        sourceFile="$(cd .. && pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ ! -e "$targetFile" ] || $skipQuestions; then

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else

            if ! $skipQuestions; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then

                    rm -rf "$targetFile"

                    execute \
                        "ln -fs $sourceFile $targetFile" \
                        "$targetFile → $sourceFile"

                else
                    print_error "$targetFile → $sourceFile"
                fi

            fi

        fi

    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "
   Create symbolic links

"
    create_symlinks "$@"
}

main "$@"
