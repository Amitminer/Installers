#!/data/data/com.termux/files/usr/bin/bash

# Color variables
BLUE="\e[1;34m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Function to display a colored message
print_message() {
  local color="$1"
  local message="$2"
  echo -e "${color}${message}${RESET}"
}

# Function to check if a file is executable
check_file_permission() {
  local script_path="$1"

  if [ -x "$script_path" ]; then
    return 0  # File is executable
  else
    return 1  # File is not executable
  fi
}

# Function to install a tool
install_tool() {
  local tool_name="$1"
  local script_path="$2"

  check_file_permission "$script_path"
  local is_executable=$?

  if [ "$is_executable" -eq 0 ]; then
    print_message "$BLUE" "Installing $tool_name..."
    ./"$script_path"
  else
    print_message "$RED" "Error: $tool_name script is not executable."
    read -p "Do you want to make it executable? (y/n): " response
    if [ "$response" = "y" ]; then
      chmod +x "$script_path"
      print_message "$GREEN" "$tool_name is now executable. Please run the script again."
      exit 1
    else
      print_message "$RED" "Exiting..."
      exit 1
    fi
  fi
}

# Main menu
main_menu() {
  echo -e "${BLUE}Please choose what you want to install on Android:${RESET}"
  echo -e "${GREEN}1. Install Kali Linux${RESET}"
  echo -e "${GREEN}2. Install Pocketmine-MP${RESET}"
  echo -e "${RED}0. Exit${RESET}"
}

# executing main_menu..
main_menu

# Get user input
read -p ": " choice

# Main logic
case $choice in
  1)
    install_tool "Kali Linux" "src/kali-linux.sh"
    ;;
  2)
    install_tool "Pocketmine-MP" "src/pocketmine-mp.sh"
    ;;
  0)
    print_message "$GREEN" "Exiting..."
    ;;
  *)
    print_message "$RED" "Invalid choice. Please enter a valid option."
    ;;
esac