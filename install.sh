#!/bin/bash

# ╔═══════════════════════════════════════╗
# ║           BADHON'S BANNER SETUP              ║
# ╚═══════════════════════════════════════╝

# ─────────────────────────────
# Colors
r='\033[1;91m'; p='\033[1;95m'; y='\033[1;93m'
g='\033[1;92m'; n='\033[0m';  b='\033[1;94m'; c='\033[1;96m'

# ─────────────────────────────
# Symbols
A="${g}[+]"
E="${r}[×]"
C="${c}[</>]"
lm="${c}▱▱▱▱▱▱▱▱▱▱▱▱〄▱▱▱▱▱▱▱▱▱▱▱▱${n}"
dm="${y}▱▱▱▱▱▱▱▱▱▱▱▱〄▱▱▱▱▱▱▱▱▱▱▱▱${n}"

# ─────────────────────────────
# Device Info
MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
VENDOR=$(getprop ro.product.manufacturer 2>/dev/null || echo "Unknown")

# ─────────────────────────────
# Exit Trap
exit_script() {
    clear
    echo
    echo -e "${c}              (\\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Goodbye!${n}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e "${y}Returning to home directory...${n}"
    cd "$HOME" || exit
    rm -rf BADHON 2>/dev/null
    exit 0
}
trap exit_script SIGINT SIGTSTP

# ─────────────────────────────
# Slow Print
sp() {
    for (( i=0; i<${#1}; i++ )); do
        echo -n "${1:$i:1}"
        sleep "${2:-0.03}"
    done
    echo
}

# ─────────────────────────────
# Pac-Man Loading Animation
pacman_loading() {
    frames=("C" "o" "O" "o")
    for i in {1..12}; do
        for f in "${frames[@]}"; do
            echo -ne "\r${y}(${f})${n} ${c}Eating bugs...${n}"
            sleep 0.1
        done
    done
    echo -e "\r${g}[✓] Done!${n}"
}

# ─────────────────────────────
# Spinner Installer
spin_install() {
    local pkg=$1
    local delay=0.12
    local spin=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    echo -ne "${y}Installing ${pkg}...${n}"
    pkg install "$pkg" -y >/dev/null 2>&1 &
    pid=$!
    while ps -p $pid > /dev/null 2>&1; do
        for s in "${spin[@]}"; do
            echo -ne "\r${c}Installing ${y}${pkg} ${g}${s}${n}"
            sleep $delay
        done
    done
    echo -e "\r${g}[✓] Installed ${pkg}${n}"
}

# ─────────────────────────────
# Network Check (Fixed – no infinite loop)
check_network() {
    clear
    echo -e "${b}╔════════════════════════╗"
    echo -e "${b}║ ${y}Checking Internet...${b} ║"
    echo -e "${b}╚════════════════════════╝${n}"
    
    # Try ping with timeout
    if ping -c 1 -W 3 google.com >/dev/null 2>&1; then
        echo -e "${A} ${g}Internet Connected!${n}"
    else
        echo -e "${r}[×] No Internet Connection Detected.${n}"
        echo -e "${y}Skipping network-dependent steps...${n}"
    fi
    sleep 1
    clear
}

# ─────────────────────────────
# Banner
show_banner() {
    clear
    echo -e "${y}"
    echo " ██████╗░░█████╗░██████╗░██╗░░██╗░█████╗░███╗░░██╗██╗░░██╗"
    echo " ██╔══██╗██╔══██╗██╔══██╗██║░░██║██╔══██╗████╗░██║╚██╗██╔╝"
    echo " ██████╦╝███████║██║░░██║███████║██║░░██║██╔██╗██║░╚███╔╝░"
    echo " ██╔══██╗██╔══██║██║░░██║██╔══██║██║░░██║██║╚████║░██╔██╗░"
    echo " ██████╦╝██║░░██║██████╔╝██║░░██║╚█████╔╝██║░╚███║██╔╝╚██╗"
    echo " ╚═════╝░╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝${n}"
    echo
    echo -e "${b}╭════════════════════════⊷"
    echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/badhon_6t9_x"
    echo -e "${b}╰════════════════════════⊷"
    echo
    echo -e "${b}┃❁ ${g}CREATOR: ${y}BADHON"
    echo -e "${b}┃❁ ${g}DEVICE: ${y}${VENDOR} ${MODEL}${n}"
    echo -e "${b}╰┈➤ ${g}Welcome, Dear User!${n}"
}

# ─────────────────────────────
# Help Screen
help() {
    clear
    echo -e "${p}■ ${g}Use Termux Extra Key Buttons${n}"
    echo -e "${y}UP/DOWN${n} to select, ${g}ENTER${n} to confirm."
    echo
    echo -e "${b}Press ENTER to continue...${n}"
    read -r
}

# ─────────────────────────────
# Package Installer
install_packages() {
    pkgs=("git" "curl" "python" "jq" "figlet" "termux-api" "ncurses-utils" "zsh" "ruby" "exa")
    for p in "${pkgs[@]}"; do
        spin_install "$p"
    done
    gem install lolcat >/dev/null 2>&1
    pip install lolcat >/dev/null 2>&1
    pacman_loading
}

# ─────────────────────────────
# Banner Setup
setup_banner() {
    mkdir -p "$HOME/.termux"
    cp "$HOME/BADHON/files/font.ttf" "$HOME/.termux/" 2>/dev/null
    cp "$HOME/BADHON/files/colors.properties" "$HOME/.termux/" 2>/dev/null
    termux-reload-settings
    echo -e "${A} ${g}Font & Color Applied!${n}"
    sleep 1
}

# ─────────────────────────────
# Username Setup
set_username() {
    clear
    echo
    echo -e "${A} ${c}Enter Your Banner Name (1-8 chars):${n}"
    while true; do
        read -p ">>> " name
        if [[ ${#name} -ge 1 && ${#name} -le 8 ]]; then
            break
        else
            echo -e "${E} ${r}Name must be between 1-8 characters.${n}"
        fi
    done
    mkdir -p "$HOME/.termux"
    echo "$name" > "$HOME/.termux/usernames.txt"
    echo -e "${A} ${g}Banner Name Saved: ${y}${name}${n}"
    sleep 1.5
}

# ─────────────────────────────
# Main Menu
main_menu() {
    options=("Free Usage" "Premium")
    selected=0
    while true; do
        clear
        show_banner
        echo
        echo -e "${p}Select Option:${n}"
        for i in "${!options[@]}"; do
            if [[ $i == $selected ]]; then
                echo -e " ${g}> ${c}${options[$i]} ${g}<${n}"
            else
                echo -e "   ${options[$i]}"
            fi
        done

        read -rsn1 key
        if [[ $key == $'\e' ]]; then
            read -rsn2 -t 0.1 key
            case $key in
                '[A') ((selected--));;
                '[B') ((selected++));;
            esac
            ((selected<0)) && selected=$((${#options[@]}-1))
            ((selected>=${#options[@]})) && selected=0
        elif [[ $key == "" ]]; then
            case ${options[$selected]} in
                "Free Usage")
                    check_network
                    show_banner
                    install_packages
                    setup_banner
                    set_username
                    clear
                    show_banner
                    echo -e "${A} ${g}Setup Complete! Restart Termux now.${n}"
                    exit 0
                    ;;
                "Premium")
                    echo -e "${y}Opening Telegram...${n}"
                    xdg-open "https://t.me/badhon_6t9_x" >/dev/null 2>&1
                    exit 0
                    ;;
            esac
        fi
    done
}

# ─────────────────────────────
# Start Script
help
main_menu
