#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh" \
    source "./utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_yarn() {

    if ! cmd_exists "yarn"; then
         execute "npm install --global --silent yarn" "Yarn"
    fi
}

install_yarn_packages() {

    install_yarn_package "commitizen" "Commitizen"
    install_yarn_package "create-react-app" "React App"
    install_yarn_package "create-react-native-app" "React Native App"
    install_yarn_package "exp" "Exp"
    install_yarn_package "flow-bin" "Flow Bin"
    install_yarn_package "lerna" "Lerna"
}

install_yarn_package() {

    declare -r CMD="global"
    declare -r YARN_PACKAGE="$1"


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `Yarn` is installed.

    if ! cmd_exists "yarn"; then
        print_error "$YARN_PACKAGE ('Yarn' não está instalado)."
        return 1
    fi

    execute "yarn $CMD add $YARN_PACKAGE"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main() {

    print_in_purple "
   Yarn

"

    install_yarn
    install_yarn_packages

}

main
