#! /bin/bash

# Banner
echo -e "\033[1;36m=============================================="
echo -e " 🔧 Proshtech Subdomain Automation Tool"
echo -e " 🔗 GitHub: https://github.com/kpoorooshasb"
echo -e "==============================================\033[0m"

domain=$1
# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if [ -z "$1" ]; then
    echo -e "$RED❌ Error: No domain provided.\ $RESET"
    echo -e "Usage: \033[1m./script.sh example.com $RESET"
    exit 1
fi

# Tools required
REQUIRED_TOOLS=("amass" "subfinder" "assetfinder" "httprobe" "gowitness")

# Check if tools are installed
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${RED}[X] $tool is not installed.${RESET}"
        echo -e "${YELLOW}[!] Please run ./install.sh to install missing tools.${RESET}"
        exit 1
    fi
done

subdomain_path=$domain/subdomains
screenshot_path=$domain/screenshots

if [ ! -d "$domain" ];then
    mkdir $domain
fi
if [ ! -d "$subdomian_path" ];then
    mkdir $subdomian_path
fi

echo -e "$RED [+] Launching Subfinder...$RESET"
subfinder -d $domain > $subdomian_path/found.txt

echo -e "$RED [+] Launching Assetfinder...$RESET"
assetfinder $domain | grep $domain >> $subdomian_path/found.txt

echo -e "$RED [+] Launching Amass...$RESET"
amass enum -d $domain  | grep $domain >> $subdomian_path/found.txt

echo -e "$RED [+] Launching httprobe for scanning live subdomains...$RESET"
cat $subdomian_path/found.txt | grep $domain | sort -u | httprobe -prefer-https | grep https | sed 's/https\?:\/\///' | tee -a $subdomian_path/alive.txt


read -p $'\e[1;33m[?] Do you want to take screenshots of alive subdomains? [Y/n]: \e[0m' screenshot_choice
screenshot_choice=${screenshot_choice:-Y} # Default to Y if empty

if [[ "$screenshot_choice" =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}[!] Skipping screenshot step.${RESET}"
else
    echo -e "${RED}[+] Taking screenshots with gowitness...${RESET}"
    if [ ! -d "$screenshot_path" ];then
    mkdir $screenshot_path
    fi
    gowitness scan file -f "$subdomain_path/alive.txt" --screenshot-path "$screenshot_path" --timeout 10 --delay 3 --write-jsonl --write-db
fi

