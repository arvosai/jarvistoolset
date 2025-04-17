#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   Cleanup

"

# Homebrew Cleanup
execute "brew cleanup" \
    "Clean up Homebrew cache and old versions"

execute "brew cleanup --prune=all" \
    "Remove all cache files older than 120 days"

execute "brew autoremove" \
    "Remove unused dependencies"

# System Cleanup
execute "rm -rf ~/Library/Caches/*" \
    "Clean up system caches"

execute "rm -rf ~/Library/Logs/*" \
    "Clean up system logs"

execute "rm -rf ~/Library/Developer/Xcode/DerivedData/*" \
    "Clean up Xcode derived data"

execute "rm -rf ~/Library/Developer/Xcode/Archives/*" \
    "Clean up Xcode archives"

# Docker Cleanup (if installed)
if command -v docker >/dev/null 2>&1; then
    execute "docker system prune -f" \
        "Clean up unused Docker data"
fi

# Node Cleanup (if installed)
if command -v npm >/dev/null 2>&1; then
    execute "npm cache clean --force" \
        "Clean up npm cache"
fi

# Ruby Cleanup (if installed)
if command -v gem >/dev/null 2>&1; then
    execute "gem cleanup" \
        "Clean up Ruby gems"
fi

# Python Cleanup (if installed)
if command -v pip3 >/dev/null 2>&1; then
    execute "pip3 cache purge" \
        "Clean up pip cache"
fi

print_in_green "
   Cleanup completed!
"
