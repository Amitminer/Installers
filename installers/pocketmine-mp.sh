#!/data/data/com.termux/files/usr/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

INSTALL_DIR="./pmmp"  # Set the installation directory

check_installation() {
    if ! command -v wget &> /dev/null; then
        echo -e "${RED}wget is not installed. Installing...${RESET}"
        apt-get update
        apt-get install wget -y
    elif ! command -v curl &> /dev/null; then
        echo -e "${RED}curl is not installed. Installing...${RESET}"
        apt-get install curl -y
    fi
}

get_latest_build_data() {
    SERVER="$(curl -s https://update.pmmp.io/api)"
    CHANNEL=$(jq -r ".channel" <<< $SERVER)
    CHANNEL_QUOTE=$(jq ".channel" <<< $SERVER)
    echo -e "[*] Retrieving latest build data for channel ${GREEN}${CHANNEL_QUOTE}${RESET}"
    PMMP_VER=$(jq -r ".base_version" <<< $SERVER)
    MCPE_VER=$(jq -r ".mcpe_version" <<< $SERVER)
    PHP_PMMP=$(jq -r ".php_version" <<< $SERVER)
    BUILD=$(jq -r ".build" <<< $SERVER)
    DATE=$(jq -r ".date" <<< $SERVER)
    DATE_CONVERT=$(date --date="@${DATE}")
    echo -e "[*] Latest stable PocketMine-MP build information:"
    echo -e "    - Version: ${GREEN}${PMMP_VER}${RESET}"
    echo -e "    - Build Number: ${GREEN}${BUILD}${RESET}"
    echo -e "    - Minecraft: PE Version: ${GREEN}v${MCPE_VER}${RESET}"
    echo -e "    - PHP Version: ${GREEN}${PHP_PMMP}${RESET}"
    echo -e "[*] This build was released on: ${GREEN}${DATE_CONVERT}${RESET}"
}

install_php_binary() {
    local php_version=8.1.22
    local php_download_url="https://github.com/DaisukeDaisuke/AndroidPHP/releases/download/${php_version}/php-next-major-gd"
    local php_ini_download_url="https://github.com/DaisukeDaisuke/AndroidPHP/releases/download/${php_version}/php-next-major.ini"

    echo -e "[*] Installing/updating PHP binary in directory ${GREEN}${INSTALL_DIR}/bin/php7/bin/${RESET}"
    mkdir -p "${INSTALL_DIR}/bin/php7/bin/"
    
    # Download and install PHP binary
    wget -qO "${INSTALL_DIR}/bin/php7/bin/php" $php_download_url
    # Download and install php.ini configuration file
    wget -qO "${INSTALL_DIR}/bin/php7/bin/php.ini" $php_ini_download_url
    
    chmod +x "${INSTALL_DIR}/bin/php7/bin/php"
}

install_pmmp() {
    local pmmp_phar_url="https://github.com/pmmp/PocketMine-MP/releases/download/${PMMP_VER}/PocketMine-MP.phar"
    local start_script_url="https://raw.githubusercontent.com/pmmp/PocketMine-MP/${PMMP_VER}/start.sh"

    echo -e "[*] Installing/updating PocketMine-MP in directory ${GREEN}${INSTALL_DIR}${RESET}"
    
    # Download PocketMine-MP.phar and start.sh script
    wget -qO "${INSTALL_DIR}/PocketMine-MP.phar" $pmmp_phar_url
    wget -qO "${INSTALL_DIR}/start.sh" $start_script_url
    
    chmod +x "${INSTALL_DIR}/start.sh"
}

main_function() {
    check_installation
    get_latest_build_data
    install_php_binary
    install_pmmp
    echo -e "[*] Everything done! Run ${GREEN}${INSTALL_DIR}/start.sh${RESET} to start PocketMine-MP"
    ./${INSTALL_DIR}/start.sh
    exit 0
}

main_function
