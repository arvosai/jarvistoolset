#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Communication and Messaging Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define arrays for each category
team_collab=(
    "slack:Slack"
    "microsoft-teams:Microsoft Teams"
    "discord:Discord"
    "zoom:Zoom"
    "webex:Webex"
    "google-meet:Google Meet"
)

messaging=(
    "whatsapp:WhatsApp"
    "telegram:Telegram"
    "signal:Signal"
    "messenger:Facebook Messenger"
    "wechat:WeChat"
    "viber:Viber"
)

video_comm=(
    "skype:Skype"
    "obs:OBS Studio"
    "streamlabs:Streamlabs"
    "elgato-control-center:Elgato Control Center"
    "elgato-stream-deck:Elgato Stream Deck"
    "krisp:Krisp"
)

email_clients=(
    "thunderbird:Thunderbird"
    "mailspring:Mailspring"
    "spark:Spark"
    "mimestream:Mimestream"
    "protonmail-bridge:ProtonMail Bridge"
    "canary-mail:Canary Mail"
)

voice_voip=(
    "mumble:Mumble"
    "teamspeak-client:TeamSpeak"
    "ventrilo:Ventrilo"
    "discord-voice:Discord Voice"
    "linphone:Linphone"
)

remote_desktop=(
    "anydesk:AnyDesk"
    "teamviewer:TeamViewer"
    "remote-desktop-manager:Remote Desktop Manager"
    "parsec:Parsec"
    "rustdesk:RustDesk"
)

screen_sharing=(
    "loom:Loom"
    "screenflow:ScreenFlow"
    "snagit:Snagit"
    "dropshare:Dropshare"
    "cloudapp:CloudApp"
)

project_mgmt=(
    "asana:Asana"
    "trello:Trello"
    "notion:Notion"
    "miro:Miro"
    "figma:Figma"
)

comm_enhancement=(
    "grammarly-desktop:Grammarly Desktop"
    "deepl:DeepL"
    "lingvanex:Lingvanex"
    "language-reactor:Language Reactor"
    "speech-central:Speech Central"
)

# Function to display menu and get user selection
display_menu() {
    local title="$1"
    shift
    local options=("$@")
    local selected=()
    
    echo "
$title:"
    for i in "${!options[@]}"; do
        local item="${options[$i]}"
        local name="${item#*:}"
        echo "   $((i+1))) $name"
    done
    
    echo "
Enter numbers (space-separated) or 'all' for all options:"
    read -r choices
    
    if [[ "$choices" == "all" ]]; then
        selected=("${options[@]}")
    else
        for num in $choices; do
            if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le "${#options[@]}" ]; then
                selected+=("${options[$((num-1))]}")
            fi
        done
    fi
    
    echo "$selected"
}

# Function to install selected tools
install_tools() {
    local tools=("$@")
    for tool in "${tools[@]}"; do
        local package="${tool%%:*}"
        local name="${tool#*:}"
        brew_install "$package" "Installing $name" true
    done
}

# Main installation logic
print_in_purple "
Do you want to install all communication tools or select individually? (all/select): "
read -r install_choice

if [[ "$install_choice" == "all" ]]; then
    # Install all tools
    print_in_purple "
Installing all communication tools...
"
    install_tools "${team_collab[@]}"
    install_tools "${messaging[@]}"
    install_tools "${video_comm[@]}"
    install_tools "${email_clients[@]}"
    install_tools "${voice_voip[@]}"
    install_tools "${remote_desktop[@]}"
    install_tools "${screen_sharing[@]}"
    install_tools "${project_mgmt[@]}"
    install_tools "${comm_enhancement[@]}"
else
    # Show category selection menu
    print_in_purple "
Select tools by category:
"
    
    print_in_purple "
1. Team Collaboration Tools"
    selected=$(display_menu "Team Collaboration" "${team_collab[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
2. Messaging Apps"
    selected=$(display_menu "Messaging Apps" "${messaging[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
3. Video Communication"
    selected=$(display_menu "Video Communication" "${video_comm[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
4. Email Clients"
    selected=$(display_menu "Email Clients" "${email_clients[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
5. Voice and VOIP"
    selected=$(display_menu "Voice and VOIP" "${voice_voip[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
6. Remote Desktop"
    selected=$(display_menu "Remote Desktop" "${remote_desktop[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
7. Screen Sharing"
    selected=$(display_menu "Screen Sharing" "${screen_sharing[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
8. Project Management"
    selected=$(display_menu "Project Management" "${project_mgmt[@]}")
    [ ! -z "$selected" ] && install_tools $selected
    
    print_in_purple "
9. Communication Enhancement"
    selected=$(display_menu "Communication Enhancement" "${comm_enhancement[@]}")
    [ ! -z "$selected" ] && install_tools $selected
fi

print_in_purple "
Communication tools installation completed!
"
