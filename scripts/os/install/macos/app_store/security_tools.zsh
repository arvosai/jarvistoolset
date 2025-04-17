#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h}
source "${SCRIPT_DIR}/utils.zsh"

print_in_purple "
   Cybersecurity Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Network Security Tools
brew_install "nmap" "Installing Nmap" false

brew_cask_install "wireshark" "Installing Wireshark" true

brew_cask_install "burp-suite" "Installing Burp Suite" true

brew_install "netcat" "Installing Netcat" false

brew_install "tcpdump" "Installing TCPDump" false

# Vulnerability Scanning
brew_cask_install "owasp-zap" "Installing OWASP ZAP" true

brew_install "nikto" "Installing Nikto" false

brew_install "sqlmap" "Installing SQLMap" false

brew_cask_install "metasploit" "Installing Metasploit" true

brew_cask_install "acunetix" "Installing Acunetix" true

# Password and Encryption Tools
brew_install "john-jumbo" "Installing John the Ripper" false

brew_install "hashcat" "Installing Hashcat" false

brew_cask_install "keepassxc" "Installing KeePassXC" true

brew_install "gnupg" "Installing GnuPG" false

brew_cask_install "veracrypt" "Installing VeraCrypt" false

# Forensics Tools
brew_cask_install "autopsy" "Installing Autopsy" true

brew_install "sleuthkit" "Installing The Sleuth Kit" false

brew_install "volatility" "Installing Volatility" false

brew_install "foremost" "Installing Foremost" false

brew_install "scalpel" "Installing Scalpel" false

# Malware Analysis
brew_cask_install "ghidra" "Installing Ghidra" true

brew_cask_install "ida-free" "Installing IDA Free" true

brew_cask_install "cutter" "Installing Cutter" true

brew_install "radare2" "Installing Radare2" false

brew_install "yara" "Installing YARA" false

# AI Security Tools
brew_cask_install "ai-security-copilot" "Installing AI Security Copilot" true

brew_cask_install "deepfence" "Installing Deepfence" true

brew_cask_install "snyk" "Installing Snyk" true

brew_cask_install "security-scorecard" "Installing Security Scorecard" true

brew_cask_install "darktrace" "Installing Darktrace" true

# Threat Intelligence
brew_cask_install "maltego" "Installing Maltego" true

brew_cask_install "misp" "Installing MISP" true

brew_install "osquery" "Installing OSQuery" false

brew_install "yeti" "Installing YETI" false

brew_cask_install "opencti" "Installing OpenCTI" false

# Web Security
brew_cask_install "burp-suite-pro" "Installing Burp Suite Pro" true

brew_cask_install "acunetix" "Installing Acunetix" true

brew_cask_install "netsparker" "Installing Netsparker" true

brew_install "wpscan" "Installing WPScan" false

brew_install "nikto" "Installing Nikto" false

# Cloud Security
brew_cask_install "prisma-cloud" "Installing Prisma Cloud" true

brew_cask_install "wiz" "Installing Wiz" true

brew_cask_install "lacework" "Installing Lacework" true

brew_cask_install "aqua-security" "Installing Aqua Security" true

brew_cask_install "orca-security" "Installing Orca Security" true

# Container Security
brew_install "trivy" "Installing Trivy" false

brew_cask_install "anchore" "Installing Anchore" true

brew_cask_install "twistlock" "Installing Twistlock" true

brew_cask_install "qualys" "Installing Qualys" true

brew_cask_install "snyk-container" "Installing Snyk Container" true

# Security Testing
brew_cask_install "kali-linux" "Installing Kali Linux" true

brew_cask_install "parrot-security" "Installing Parrot Security" true

brew_cask_install "pentestbox" "Installing PentestBox" true

brew_cask_install "blackarch" "Installing BlackArch" true

# AI-Powered Security Analysis
brew_cask_install "vectra-ai" "Installing Vectra AI" true

brew_cask_install "exabeam" "Installing Exabeam" true

brew_cask_install "cybereason" "Installing Cybereason" true

brew_cask_install "crowdstrike" "Installing CrowdStrike" true

brew_cask_install "sentinel-one" "Installing SentinelOne" true

# Security Monitoring
brew_cask_install "splunk" "Installing Splunk" true

brew_cask_install "elastic-security" "Installing Elastic Security" true

brew_cask_install "qradar" "Installing QRadar" true

brew_cask_install "arcsight" "Installing ArcSight" true

brew_cask_install "logrhythm" "Installing LogRhythm" true

# Privacy Tools
brew_cask_install "tor" "Installing Tor" false

brew_cask_install "tails" "Installing Tails" true

brew_cask_install "protonvpn" "Installing ProtonVPN" true

brew_cask_install "mullvadvpn" "Installing Mullvad VPN" true

brew_cask_install "signal" "Installing Signal" true

# Security Development
brew_cask_install "security-code-scan" "Installing Security Code Scan" true

brew_cask_install "checkmarx" "Installing Checkmarx" true

brew_cask_install "fortify" "Installing Fortify" true

brew_cask_install "sonarqube" "Installing SonarQube" true

brew_cask_install "veracode" "Installing Veracode" true
