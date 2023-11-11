#!/data/data/com.termux/files/usr/bin/bash

# Color variables
RED='\e[31m'
GREEN='\e[32m'
CYAN='\e[36m'
RESET='\e[0m'

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo -e "${RED}wget is not installed. Installing...${RESET}"
    apt-get update
    apt-get install wget -y
else
    echo -e "${GREEN}wget is already installed.${RESET}"
fi

# Download the Kali Linux installer using wget
wget -O install.sh https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project/raw/master/nethunter-rootless/install-nethunter-termux

# Check if download was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully Downloaded Installer of Kali Linux.${RESET}"
else
    echo -e "${RED}Download failed.${RESET}"
    exit 1
fi

# Make the script executable
chmod +x install.sh

# Execute the install.sh script and provide input to select option 1
echo "1" | bash install.sh

# Additional commands after installation
echo -e "${CYAN}Executing additional commands...${RESET}"
nethunter
echo -e "${GREEN}Successfully installed Kali-Linux in Your Android.(for running Kali Linux use nethunter or nh${RESET}"

# Remove install.sh after installation completed
rm -f install.sh
