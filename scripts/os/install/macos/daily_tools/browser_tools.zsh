#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Browser Extensions and Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install Brave Browser
execute "brew install --cask brave-browser" \
    "Installing Brave Browser"

# AI Extensions
execute "echo 'Installing AI Extensions for Brave:'" \
    "AI Extensions Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/chatgpt-for-brave/jgjkjpnhkcgcdgejbffkmbfompkepkbe" \
    "Installing ChatGPT for Brave"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/claude-ai/kkfngpgjcedkdpipcpbggfkcnkfbpmid" \
    "Installing Claude AI"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/bard-ai/nmpbpmgkokjpjhkjphjgdgmgbgjcooke" \
    "Installing Bard AI"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/github-copilot/codcgekjehkbfmlkbfhodjlhpfbkdlbpi" \
    "Installing GitHub Copilot"

# Productivity Extensions
execute "echo 'Installing Productivity Extensions for Brave:'" \
    "Productivity Extensions Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/notion-web-clipper/knheggckgoiihginacbkhaalnibhilkk" \
    "Installing Notion Web Clipper"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/grammarly/kbfnbcaeplbcioakkpcpgfkobkghlhen" \
    "Installing Grammarly"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/todoist/jldhpllghnbhlbpcmnajkpdmadaolakh" \
    "Installing Todoist"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/raindropio/ldgfbffkinooeloadekpmfoklnobpien" \
    "Installing Raindrop.io Bookmarks Manager"

# Development Extensions
execute "echo 'Installing Development Extensions for Brave:'" \
    "Development Extensions Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi" \
    "Installing React Developer Tools"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd" \
    "Installing Redux DevTools"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/vue-devtools/nhdogjmejiglipccpnnnanhbledajbpd" \
    "Installing Vue DevTools"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/json-viewer/gbmdgpbipfallnflgajpaliibnhdgobh" \
    "Installing JSON Viewer"

# Security Extensions
execute "echo 'Installing Security Extensions for Brave:'" \
    "Security Extensions Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm" \
    "Installing uBlock Origin"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/privacy-badger/pkehgijcmpdhfbdbbnkijodmdjhbjlgp" \
    "Installing Privacy Badger"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/https-everywhere/gcbommkclmclpchllfjekcdonpmejbdp" \
    "Installing HTTPS Everywhere"

# Development Tools
execute "echo 'Installing Development Tools Extensions for Brave:'" \
    "Development Tools Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/wappalyzer/gppongmhjkpfnbhagpmjfkannfbllamg" \
    "Installing Wappalyzer"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk" \
    "Installing Lighthouse"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/axe-devtools-web-accessib/lhdoppojpmngadmnindnejefpokejbdd" \
    "Installing axe DevTools"

# API Testing
execute "echo 'Installing API Testing Extensions for Brave:'" \
    "API Testing Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop" \
    "Installing Postman"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/talend-api-tester-free-ed/aejoelaoggembcahagimdiliamlcdmfm" \
    "Installing Talend API Tester"

# Design Tools
execute "echo 'Installing Design Tools Extensions for Brave:'" \
    "Design Tools Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/colorpick-eyedropper/ohcpnigalekghcmgcdcenkpelffpdolg" \
    "Installing ColorPick Eyedropper"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/perfectpixel-by-welldonec/dkaagdgjmgdmbnecmcefdhjekcoceebi" \
    "Installing Perfect Pixel"

# Code Quality
execute "echo 'Installing Code Quality Extensions for Brave:'" \
    "Code Quality Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/web-developer/bfbameneiokkgbdmiekhjnmfkcnldhhm" \
    "Installing Web Developer"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/css-peeper/mbnbehikldjhnfehhnaidhjhoofhpehk" \
    "Installing CSS Peeper"

# Git Tools
execute "echo 'Installing Git Extensions for Brave:'" \
    "Git Extensions Notice"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/refined-github/hlepfoohegkhhmjieoechaddaejaokhf" \
    "Installing Refined GitHub"

execute "open -a 'Brave Browser' https://chrome.google.com/webstore/detail/gitzip-for-github/ffabmkklhbepgcgfonabamgnfafbdlkn" \
    "Installing GitZip for GitHub"

# Note: After running this script, you'll need to manually complete the installation
# of each extension in the Brave Browser.
