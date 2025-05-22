#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

echo -e "${YELLOW}[+] Starting installation of required tools for Kali Linux...${RESET}"

# 1. Install Go if not installed
if ! command -v go &> /dev/null; then
    echo -e "${YELLOW}[!] Go not found. Installing Go...${RESET}"
    
    sudo apt update
    sudo apt install -y golang

    # Ensure Go bin path is in PATH
    echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
    export PATH=$PATH:$HOME/go/bin

    echo -e "${GREEN}[+] Go installed successfully.${RESET}"
else
    echo -e "${GREEN}[+] Go is already installed.${RESET}"
fi

# 2. Function to check and install tool
install_tool() {
    local tool=$1
    local install_cmd=$2

    if ! command -v $tool &> /dev/null; then
        echo -e "${YELLOW}[!] $tool not found. Installing...${RESET}"
        eval "$install_cmd"
        echo -e "${GREEN}[+] $tool installed successfully.${RESET}"
    else
        echo -e "${GREEN}[+] $tool is already installed.${RESET}"
    fi
}

# 3. Install required tools
install_tool "amass" "sudo apt install -y amass"
install_tool "subfinder" "go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
install_tool "assetfinder" "go install github.com/tomnomnom/assetfinder@latest"
install_tool "httprobe" "go install github.com/tomnomnom/httprobe@latest"
install_tool "gowitness" "go install github.com/sensepost/gowitness@latest"

# 4. Ensure tools from Go bin are usable
echo -e "${YELLOW}[!] Verifying \$HOME/go/bin is in PATH...${RESET}"
if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
    export PATH=$PATH:$HOME/go/bin
    echo -e "${GREEN}[+] Added \$HOME/go/bin to PATH.${RESET}"
fi

# 5. Done
echo -e "${GREEN}[✔] All tools installed successfully. You can now run your recon script.${RESET}"
