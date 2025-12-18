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

echo -e "${BOLD}${GREEN}💾 Memory Usage:${NC}"
echo -e "   ${BLUE}Total:${NC}      $MEMORY_TOTAL"
echo -e "   ${BLUE}Used:${NC}       $MEMORY_USED"
echo -e "   ${BLUE}Available:${NC}  $MEMORY_AVAILABLE"
echo ""

# Disk usage for root
DISK_USAGE=$(df -h / | tail -1)
DISK_SIZE=$(echo $DISK_USAGE | awk '{print $2}')
DISK_USED=$(echo $DISK_USAGE | awk '{print $3}')
DISK_AVAILABLE=$(echo $DISK_USAGE | awk '{print $4}')
DISK_PERCENT=$(echo $DISK_USAGE | awk '{print $5}')

echo -e "${BOLD}${GREEN}💽 Disk Usage (Root):${NC}"
echo -e "   ${BLUE}Size:${NC}       $DISK_SIZE"
echo -e "   ${BLUE}Used:${NC}       $DISK_USED ($DISK_PERCENT)"
echo -e "   ${BLUE}Available:${NC}  $DISK_AVAILABLE"
echo ""

# Welcome message and tips
echo -e "${BOLD}${PURPLE}🌟 Welcome to your new weebo-OS experience!${NC}"
echo ""
echo -e "${YELLOW}✨ Features & Tips:${NC}"
echo -e "   • Built on Fedora with modern containerization"
echo -e "   • Immutable OS design for enhanced security"
echo -e "   • Automatic updates keep your system current"
echo -e "   • Container-first workflow for development"
echo ""

echo -e "${YELLOW}🚀 Quick Start:${NC}"
echo -e "   • Run ${CYAN}toolbox create${NC} to create a development environment"
echo -e "   • Use ${CYAN}flatpak${NC} to install applications"
echo -e "   • Check ${CYAN}systemctl status${NC} for system health"
echo ""

# Check if running in VirtualBox
if lscpu | grep -q "Hypervisor vendor:.*VirtualBox" 2>/dev/null || 
   dmesg | grep -qi "vboxguest" 2>/dev/null; then
    echo -e "${BOLD}${CYAN}📦 VirtualBox Environment Detected${NC}"
    echo -e "   • Install VirtualBox Guest Additions for better performance"
    echo -e "   • Enable shared folders and clipboard integration"
    echo ""
fi

echo -e "${BOLD}${WHITE}═══════════════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}Enjoy your weebo-OS experience! 🎉${NC}"
echo -e "${BOLD}${WHITE}═══════════════════════════════════════════════════════════════════${NC}"
echo ""