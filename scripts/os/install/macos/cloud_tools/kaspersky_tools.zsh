#!/bin/zsh

# Get the directory of the current script
SCRIPT_DIR=${0:a:h} \
    source "../../utils.zsh"

print_in_purple "
   Kaspersky Security Tools

"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core Security Solutions
brew_install "kaspersky-endpoint-security" "Installing Kaspersky Endpoint Security" true

brew_install "kaspersky-security-cloud" "Installing Kaspersky Security Cloud" true

brew_install "kaspersky-total-security" "Installing Kaspersky Total Security" true

brew_install "kaspersky-internet-security" "Installing Kaspersky Internet Security" true

brew_install "kaspersky-antivirus" "Installing Kaspersky Antivirus" true

# Enterprise Security Solutions
brew_install "kaspersky-edr" "Installing Kaspersky EDR" true

brew_install "kaspersky-security-center" "Installing Kaspersky Security Center" true

brew_install "kaspersky-sandbox" "Installing Kaspersky Sandbox" true

brew_install "kaspersky-hybrid-cloud-security" "Installing Kaspersky Hybrid Cloud Security" true

brew_install "kaspersky-security-network" "Installing Kaspersky Security Network" true

# AI-Powered Security Tools
brew_install "kaspersky-security-intelligence" "Installing Kaspersky Security Intelligence" true

brew_install "kaspersky-threat-intelligence" "Installing Kaspersky Threat Intelligence" true

brew_install "kaspersky-automated-security" "Installing Kaspersky Automated Security" true

brew_install "kaspersky-neural-networks" "Installing Kaspersky Neural Networks" true

brew_install "kaspersky-machine-learning" "Installing Kaspersky Machine Learning" true

# Industrial Security
brew_install "kaspersky-ics" "Installing Kaspersky Industrial CyberSecurity" true

brew_install "kaspersky-iot-secure" "Installing Kaspersky IoT Secure Gateway" true

brew_install "kaspersky-embedded-security" "Installing Kaspersky Embedded Systems Security" true

brew_install "kaspersky-industrial-protection" "Installing Kaspersky Industrial Protection" true

brew_install "kaspersky-scada-security" "Installing Kaspersky SCADA Security" true

# Threat Prevention
brew_install "kaspersky-apt-secure" "Installing Kaspersky Anti Targeted Attack" true

brew_install "kaspersky-ddos-protection" "Installing Kaspersky DDoS Protection" true

brew_install "kaspersky-fraud-prevention" "Installing Kaspersky Fraud Prevention" true

brew_install "kaspersky-threat-prevention" "Installing Kaspersky Threat Prevention" true

brew_install "kaspersky-breach-prevention" "Installing Kaspersky Breach Prevention" true

# Security Assessment Tools
brew_install "kaspersky-security-assessment" "Installing Kaspersky Security Assessment" true

brew_install "kaspersky-penetration-testing" "Installing Kaspersky Penetration Testing" true

brew_install "kaspersky-vulnerability-scanner" "Installing Kaspersky Vulnerability Scanner" true

brew_install "kaspersky-security-audit" "Installing Kaspersky Security Audit" true

brew_install "kaspersky-compliance-check" "Installing Kaspersky Compliance Check" true

# Privacy Protection
brew_install "kaspersky-vpn-secure" "Installing Kaspersky VPN Secure Connection" true

brew_install "kaspersky-password-manager" "Installing Kaspersky Password Manager" true

brew_install "kaspersky-safe-kids" "Installing Kaspersky Safe Kids" true

brew_install "kaspersky-safe-banking" "Installing Kaspersky Safe Banking" true

brew_install "kaspersky-privacy-protection" "Installing Kaspersky Privacy Protection" true

# Mobile Security
brew_install "kaspersky-mobile-security" "Installing Kaspersky Mobile Security" true

brew_install "kaspersky-mobile-antivirus" "Installing Kaspersky Mobile Antivirus" true

brew_install "kaspersky-mdm" "Installing Kaspersky Mobile Device Management" true

brew_install "kaspersky-mobile-threat-defense" "Installing Kaspersky Mobile Threat Defense" true

brew_install "kaspersky-mobile-protection" "Installing Kaspersky Mobile Protection" true

# Security Management
brew_install "kaspersky-security-manager" "Installing Kaspersky Security Manager" true

brew_install "kaspersky-security-center-cloud" "Installing Kaspersky Security Center Cloud" true

brew_install "kaspersky-unified-monitoring" "Installing Kaspersky Unified Monitoring" true

brew_install "kaspersky-security-orchestration" "Installing Kaspersky Security Orchestration" true

brew_install "kaspersky-incident-response" "Installing Kaspersky Incident Response" true

# Development Security
brew_install "kaspersky-secure-dev" "Installing Kaspersky Secure Development" true

brew_install "kaspersky-appsec" "Installing Kaspersky Application Security" true

brew_install "kaspersky-devsecops" "Installing Kaspersky DevSecOps" true

brew_install "kaspersky-code-security" "Installing Kaspersky Code Security" true

brew_install "kaspersky-container-security" "Installing Kaspersky Container Security" true
