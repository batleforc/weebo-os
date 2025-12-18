#!/bin/bash

# weebo-OS Welcome Message
# Displays system information and welcome message with ASCII art

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ASCII Art for weebo-OS
echo -e "${CYAN}"
cat << 'EOF'
 ██╗    ██╗███████╗███████╗██████╗  ██████╗       ██████╗ ███████╗
 ██║    ██║██╔════╝██╔════╝██╔══██╗██╔═══██╗     ██╔═══██╗██╔════╝
 ██║ █╗ ██║█████╗  █████╗  ██████╔╝██║   ██║     ██║   ██║███████╗
 ██║███╗██║██╔══╝  ██╔══╝  ██╔══██╗██║   ██║     ██║   ██║╚════██║
 ╚███╔███╔╝███████╗███████╗██████╔╝╚██████╔╝     ╚██████╔╝███████║
  ╚══╝╚══╝ ╚══════╝╚══════╝╚═════╝  ╚═════╝       ╚═════╝ ╚══════╝
EOF
echo -e "${NC}"

# Welcome message
echo -e "${BOLD}${WHITE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${YELLOW}                    Welcome to weebo-OS!${NC}"
echo -e "${BOLD}${WHITE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""

# System Information
echo -e "${BOLD}${GREEN}🖥️  System Information:${NC}"
echo -e "   ${BLUE}Host:${NC}     $(hostname)"
echo -e "   ${BLUE}Kernel:${NC}   $(uname -r)"
echo -e "   ${BLUE}Uptime:${NC}   $(uptime -p)"
echo -e "   ${BLUE}Date:${NC}     $(date)"
echo ""

# Get memory info
MEMORY_INFO=$(free -h | grep '^Mem:')
MEMORY_TOTAL=$(echo $MEMORY_INFO | awk '{print $2}')
MEMORY_USED=$(echo $MEMORY_INFO | awk '{print $3}')
MEMORY_AVAILABLE=$(echo $MEMORY_INFO | awk '{print $7}')

# Disk usage for root
DISK_USAGE=$(df -h / | tail -1)
DISK_SIZE=$(echo $DISK_USAGE | awk '{print $2}')
DISK_USED=$(echo $DISK_USAGE | awk '{print $3}')
DISK_AVAILABLE=$(echo $DISK_USAGE | awk '{print $4}')
DISK_PERCENT=$(echo $DISK_USAGE | awk '{print $5}')

printf "${BOLD}${GREEN}💾 Memory Usage:${NC}%18s${BOLD}${GREEN}💽 Disk Usage (Root):${NC}\n" ""
printf "   ${BLUE}Total:${NC}      %-10s%10s${BLUE}Size:${NC}       %s\n" "$MEMORY_TOTAL" "" "$DISK_SIZE"
printf "   ${BLUE}Used:${NC}       %-10s%10s${BLUE}Used:${NC}       %s (%s)\n" "$MEMORY_USED" "" "$DISK_USED" "$DISK_PERCENT"
printf "   ${BLUE}Available:${NC}  %-10s%10s${BLUE}Available:${NC}  %s\n" "$MEMORY_AVAILABLE" "" "$DISK_AVAILABLE"
echo ""

# If first login, display additional tips
if [ ! -f $HOME/.config/.first_login_done ]; then

# Welcome message and tips
echo -e "${YELLOW}✨ Features & Tips:${NC}"
echo -e "   • Immutable OS based on Fedora Atomic for security and stability"
echo -e "   • Automatic updates keep your system current with easy rollbacks"
echo -e "   • Container-first workflow for development"
echo ""

touch $HOME/.config/.first_login_done
fi

echo -e "${YELLOW}🚀 Quick Start:${NC}"
echo -e "   • Run ${CYAN}toolbox create${NC} to create a development environment"
echo -e "   • Use ${CYAN}flatpak${NC} to install applications"
echo -e "   • Check ${CYAN}systemctl status${NC} for system health"
echo ""

echo -e "${BOLD}${WHITE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}Enjoy your weebo-OS experience! 🎉${NC}"
echo -e "${BOLD}${WHITE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""