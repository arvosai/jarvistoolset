#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
login_to_app_store() {

    execute "mas signin '$USERNAME'"

}

install_mas() {

    print_in_purple "
   >>> Installing Mac App Store CLI

"
    brew_install "Mac App Store CLI" "mas"

}

upgrade_mas_apps() {

    print_in_purple "
   >>> Updating Apps from App Store

"
    execute "mas upgrade" "Updating Apps"
}

install_mas_apps() {

    print_in_purple "
   >>> Installing Apps from App Store

"

    execute "mas install 414209656	" "Better Rename 9  (9.52)"
    execute "mas install 1286725949	" "Cappuccino­ (10.0.12)"
    execute "mas install 424389933	" "Final Cut Pro (10.4.4)"
    execute "mas install 412448059	" "ForkLift - File Manager and FTP/SFTP/WebDAV/Amazon (2.6.6)"
    execute "mas install 445770608	" "Go2Shell (1.2.2)"
    execute "mas install 409183694  " "Keynote (8.3)"
    execute "mas install 405399194	" "Kindle (1.23.2)"
    execute "mas install 1295203466	" "Microsoft Remote Desktop 10 (10.2.4)"
    execute "mas install 461788075	" "Movist (2.0.5)"
    execute "mas install 409203825  " "Numbers (5.3)"
    execute "mas install 409201541  " "Pages (7.3)"
    execute "mas install 407963104	" "Pixelmator (3.8.1)"
    execute "mas install 863486266	" "Autodesk SketchBook  (8.6.1)"
    execute "mas install 1208561404 " "Kaspersky VPN Connection   (2.1.1) "
    execute "mas install 1140461273 " "Kaspersky Password Manager (9.1.1)"
    execute "mas install 1268962404 " "Smart JSON Editor (1.4.5)"
    execute "mas install 1116599239 " "NordVPN IKE - Unlimited VPN (4.8.7)"
    execute "mas install 1147396723 " "WhatsApp Desktop (0.3.1850)"
    execute "mas install 803453959  " "Slack (3.3.3)"
    execute "mas install 823766827  " "OneDrive (18.214.1021)"
    execute "mas install 406056744  " "Evernote (7.7)"
    execute "mas install 1278508951 " "Trello (2.10.8)"
    execute "mas install 837352001  " "Maxel (2.4.1)"
}

main() {

    print_in_purple "
 >> Installing apps from Mac App Store

"

    install_mas
    login_to_app_store
    upgrade_mas_apps
    install_mas_apps

}

main
