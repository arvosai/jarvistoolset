#!/usr/bin/env zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/../../utils.zsh"
source "${SCRIPT_DIR}/utils.zsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print_in_purple "
   JetBrains Tools

"

# IDEs for different languages/platforms
brew_install "IntelliJ IDEA Ultimate" "intellij-idea" "--cask"
brew_install "PyCharm Professional" "pycharm" "--cask"
brew_install "WebStorm" "webstorm" "--cask"
brew_install "PhpStorm" "phpstorm" "--cask"
brew_install "CLion" "clion" "--cask"
brew_install "GoLand" "goland" "--cask"
brew_install "RubyMine" "rubymine" "--cask"
brew_install "DataGrip" "datagrip" "--cask"
brew_install "Rider" "rider" "--cask"

# Mobile Development
brew_install "AppCode" "appcode" "--cask"
brew_install "Android Studio" "android-studio" "--cask"

# Other JetBrains Tools
brew_install "JetBrains Toolbox" "jetbrains-toolbox" "--cask"
brew_install "JetBrains Space" "jetbrains-space" "--cask"

# Optional Tools
# Uncomment if needed
# brew_install "MPS" "mps" "--cask"
# brew_install "JetBrains Gateway" "jetbrains-gateway" "--cask"
# brew_install "DataSpell" "dataspell" "--cask"
# brew_install "Fleet" "fleet" "--cask"

# Configure JetBrains settings directory
JETBRAINS_DIR="$HOME/Library/Application Support/JetBrains"
if [[ ! -d "$JETBRAINS_DIR" ]]; then
    mkdir -p "$JETBRAINS_DIR"
fi

# Set up JVM options for better performance
cat > "$HOME/.jetbrains.vmoptions" << 'EOL'
-Xms2g
-Xmx4g
-XX:ReservedCodeCacheSize=1g
-XX:+UseG1GC
-XX:SoftRefLRUPolicyMSPerMB=50
-XX:CICompilerCount=2
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-ea
-Dsun.io.useCanonCaches=false
-Djdk.http.auth.tunneling.disabledSchemes=""
-Djdk.attach.allowAttachSelf=true
-XX:ErrorFile=$HOME/java_error_in_idea_%p.log
-XX:HeapDumpPath=$HOME/java_error_in_idea.hprof
EOL

print_result $? "JetBrains VM options"
