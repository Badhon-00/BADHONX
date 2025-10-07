#!/bin/bash

clear

# dx color
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'

# dx Symbol
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# dx icon
OS="\uf6a6"
HOST="\uf6c3"
KER="\uf83c"
UPT="\uf49b"
PKGS="\uf8d6"
SH="\ue7a2"
TERMINAL="\uf489"
CHIP="\uf2db"
CPUI="\ue266"
HOMES="\uf015"

MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
VENDOR=$(getprop ro.product.manufacturer 2>/dev/null || echo "Unknown")
devicename="${VENDOR} ${MODEL}"
THRESHOLD=100
random_number=$(( RANDOM % 2 ))

exit_script() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"              
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}Badhon Banner \033[1;36m"
    echo
    cd "$HOME"
    rm -rf BADHON 2>/dev/null
    exit 0
}

trap exit_script SIGINT SIGTSTP

check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size
    local used_size
    local disk_usage

    if command -v df >/dev/null 2>&1; then
        total_size=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $2}')
        used_size=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $3}')
        disk_usage=$(df "$HOME" 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//g')
        
        if [ -n "$disk_usage" ] && [ "$disk_usage" -ge "$threshold" ] 2>/dev/null; then
            echo -e "${g}[${n}\uf0a0${g}] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
        elif [ -n "$disk_usage" ]; then
            echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
        else
            echo -e "${y}Disk usage: ${g}Unknown"
        fi
    else
        echo -e "${y}Disk usage: ${g}Unknown"
    fi
}

sp() {
    local sentence=$1
    local second=${2:-0.05}
    for (( i=0; i<${#sentence}; i++ )); do
        char="${sentence:$i:1}"
        echo -n "$char"
        sleep "$second"
    done
    echo
}

mkdir -p "$HOME/.Badhon" 2>/dev/null

tr() {
    if ! command -v curl >/dev/null 2>&1; then
        pkg install curl -y >/dev/null 2>&1
    fi
    if ! command -v clear >/dev/null 2>&1; then
        pkg install ncurses-utils -y >/dev/null 2>&1
    fi
}

help() {
    clear
    echo
    echo -e " ${p}■ \e[4m${g}Use Button\e[0m ${p}▪︎${n}"
    echo
    echo -e " ${y}Use Termux Extra key Button${n}"
    echo
    echo -e " UP          ↑"
    echo -e " DOWN        ↓"
    echo
    echo -e " ${g}Select option Click Enter button"
    echo
    echo -e " ${b}■ \e[4m${c}If you understand, click the Enter Button\e[0m ${b}▪︎${n}"
    read -r -p ""
}

spin() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    show_spinner() {
        local pid=$1
        local package_name=$2
        while ps -p "$pid" > /dev/null 2>&1; do
            for i in "${spinner[@]}"; do
                echo -ne "\033[1;96m\r [+] Installing $package_name please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep "$delay"
            done
        done
        printf "   \b\b\b\b\b"
        printf "\e[1;93m [Done $package_name]\e[0m\n"
        echo
        sleep 1
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")

    for package in "${packages[@]}"; do
        pkg install "$package" -y >/dev/null 2>&1 &
        show_spinner $! "$package"
    done

    pip install lolcat >/dev/null 2>&1
    rm -rf data/data/com.termux/files/usr/bin/chat >/dev/null 2>&1
    mkdir -p "$HOME/.Badhon" 2>/dev/null
    mv "$HOME/BADHON/files/report" "$HOME/.Badhon/" 2>/dev/null
    mv "$HOME/BADHON/files/chat.sh" /data/data/com.termux/files/usr/bin/chat 2>/dev/null
    chmod +x /data/data/com.termux/files/usr/bin/chat 2>/dev/null
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1
    rm -rf /data/data/com.termux/files/usr/etc/motd 2>/dev/null
    chsh -s zsh 2>/dev/null
    rm -rf ~/.zshrc >/dev/null 2>&1
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc 2>/dev/null
    git clone https://github.com/zsh-users/zsh-autosuggestions /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
    echo "y" | gem install lolcat > /dev/null 2>&1
}

setup() {
    ds="$HOME/.termux"
    dx="$ds/font.ttf"
    badhon="$ds/colors.properties"
    
    mkdir -p "$ds" 2>/dev/null
    
    if [ ! -f "$dx" ]; then
        cp "$HOME/BADHON/files/font.ttf" "$ds/" 2>/dev/null
    fi

    if [ ! -f "$badhon" ]; then
        cp "$HOME/BADHON/files/colors.properties" "$ds/" 2>/dev/null
    fi
    
    mkdir -p "$PREFIX/share/figlet/" 2>/dev/null
    cp "$HOME/BADHON/files/ASCII-Shadow.flf" "$PREFIX/share/figlet/" 2>/dev/null
    mv "$HOME/BADHON/files/remove" /data/data/com.termux/files/usr/bin/ 2>/dev/null
    chmod +x /data/data/com.termux/files/usr/bin/remove 2>/dev/null
    termux-reload-settings 2>/dev/null
}

dxnetcheck() {
    clear
    echo
    echo -e "               ${g}╔═══════════════╗"
    echo -e "               ${g}║ ${n}</>  ${c}BADHON${g}    ║"
    echo -e "               ${g}╚═══════════════╝"
    echo -e "  ${g}╔════════════════════════════════════════════╗"
    echo -e "  ${g}║  ${C} ${y}Checking Your Internet Connection¡${g}  ║"
    echo -e "  ${g}╚════════════════════════════════════════════╝${n}"
    
    while true; do
        if curl --silent --head --fail https://github.com > /dev/null 2>&1; then
            break
        else
            echo -e "              ${g}╔══════════════════╗"
            echo -e "              ${g}║${C} ${r}No Internet ${g}║"
            echo -e "              ${g}╚══════════════════╝"
            sleep 2.5
        fi
    done
    clear
}

donotchange() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e " ${A} ${c}Please Enter Your ${g}Banner Name${c}"
    echo

    while true; do
        read -p "[+]──[Enter Your Name]────► " name
        echo

        if [[ ${#name} -ge 1 && ${#name} -le 8 ]]; then
            break
        else
            echo -e " ${E} ${r}Name must be between ${g}1 and 8${r} characters. ${y}Please try again.${c}"
            echo
        fi
    done

    D1="$HOME/.termux"
    USERNAME_FILE="$D1/usernames.txt"
    VERSION="$D1/dx.txt"
    INPUT_FILE="$HOME/BADHON/files/.zshrc"
    THEME_INPUT="$HOME/BADHON/files/.badhon.zsh-theme"
    OUTPUT_ZSHRC="$HOME/.zshrc"
    OUTPUT_THEME="$HOME/.oh-my-zsh/themes/badhon.zsh-theme"
    TEMP_FILE="$HOME/temp.zshrc"

    sed "s/BADHON/$name/g" "$INPUT_FILE" > "$TEMP_FILE" 2>/dev/null
    sed "s/BADHON/$name/g" "$THEME_INPUT" > "$OUTPUT_THEME" 2>/dev/null
    echo "$name" > "$USERNAME_FILE"
    echo "version 1.5" > "$VERSION"

    if [[ $? -eq 0 ]]; then
        mv "$TEMP_FILE" "$OUTPUT_ZSHRC" 2>/dev/null
        clear
        echo
        echo
        echo -e "		        ${g}Hey ${y}$name"
        echo -e "${c}              (\_/)"
        echo -e "              (${y}^ω^${c})     ${g}I'm Badhon${c}"
        echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
        echo
        echo -e " ${A} ${c}Your Banner created ${g}Successfully¡${c}"
        echo
        sleep 3
    else
        echo
        echo -e " ${E} ${r}Error occurred while processing the file."
        sleep 1
        rm -f "$TEMP_FILE" 2>/dev/null
    fi

    clear
}

banner() {
    clear
    echo
    echo -e "    ${y}╔══╗╔═══╦═══╦╗─╔╦═══╦═╗─╔╗"
    echo -e "    ${y}║╔╗║║╔═╗╠╗╔╗║║─║║╔═╗║║╚╗║║"
    echo -e "    ${y}║╚╝╚╣║─║║║║║║╚═╝║║─║║╔╗╚╝║"
    echo -e "    ${c}║╔═╗║╚═╝║║║║║╔═╗║║─║║║╚╗║║"
    echo -e "    ${c}║╚═╝║╔═╗╠╝╚╝║║─║║╚═╝║║─║║║"
    echo -e "    ${c}╚═══╩╝─╚╩═══╩╝─╚╩═══╩╝─╚═╝${n}"
    echo
    
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/TermuxBadhon"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/alphabadhon369"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    
    echo
    echo -e "${b}╭══ ${g}〄 ${y}ʙᴀᴅʜᴏɴ ${g}〄"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}ʙᴀᴅʜᴏɴ"
    echo -e "${b}┃❁ ${g}ᴅᴇᴠɪᴄᴇ: ${y}${VENDOR} ${MODEL}"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
}

termux() {
    spin
}

setupx() {
    if [ -d "/data/data/com.termux/files/usr/" ]; then
        tr
        dxnetcheck
        
        banner
        echo -e " ${C} ${y}Detected Termux on Android¡"
        echo -e " ${lm}"
        echo -e " ${A} ${g}Updating Package..¡"
        echo -e " ${dm}"
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        echo -e " ${lm}"
        termux
        
        if [ -d "$HOME/BADHON" ]; then
            sleep 2
            clear
            banner
            echo -e " ${A} ${p}Updating Completed...!¡"
            echo -e " ${dm}"
            clear
            banner
            echo -e " ${C} ${c}Package Setup Your Termux..${n}"
            echo
            echo -e " ${A} ${g}Wait a few minutes.${n}"
            setup
            donotchange
            clear
            banner
            echo -e " ${C} ${c}Type ${g}exit ${c} then ${g}enter ${c}Now Open Your Termux¡¡ ${g}[${n}${HOMES}${g}]${n}"
            echo
            sleep 3
            cd "$HOME"
            rm -rf BADHON 2>/dev/null
            exit 0
        else
            clear
            banner
            echo -e " ${E} ${r}Tools Not Exits Your Terminal.."
            echo
            echo
            sleep 3
            exit 1
        fi
    else
        echo -e " ${E} ${r}Sorry, this operating system is not supported ${p}| ${g}[${n}${HOST}${g}] ${SHELL}${n}"
        echo 
        echo -e " ${A} ${g} Wait for the next update using Linux...!¡"
        echo
        sleep 3
        exit 1
    fi
}

banner2() {
    clear
    echo
    echo -e "    ${y}╔══╗╔═══╦═══╦╗─╔╦═══╦═╗─╔╗"
    echo -e "    ${y}║╔╗║║╔═╗╠╗╔╗║║─║║╔═╗║║╚╗║║"
    echo -e "    ${y}║╚╝╚╣║─║║║║║║╚═╝║║─║║╔╗╚╝║"
    echo -e "    ${c}║╔═╗║╚═╝║║║║║╔═╗║║─║║║╚╗║║"
    echo -e "    ${c}║╚═╝║╔═╗╠╝╚╝║║─║║╚═╝║║─║║║"
    echo -e "    ${c}╚═══╩╝─╚╩═══╩╝─╚╩═══╩╝─╚═╝${n}"
    echo
    
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/TermuxBadhon"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/alphabadhon369"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    
    echo
    echo -e "${b}╭══ ${g}〄 ${y}ʙᴀᴅʜᴏɴ ${g}〄"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}ʙᴀᴅʜᴏɴ"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
    echo -e "${c}╭════════════════════════════════════════════════⊷"
    echo -e "${c}┃ ${p}❏ ${g}Choose what you want to use. then Click Enter${n}"
    echo -e "${c}╰════════════════════════════════════════════════⊷"
}

main_menu() {
    options=("Free Usage" "Premium")
    selected=0

    display_menu() {
        clear
        banner2
        echo
        echo -e " ${g}■ \e[4m${p}Select An Option\e[0m ${g}▪︎${n}"
        echo
        for i in "${!options[@]}"; do
            if [ $i -eq $selected ]; then
                echo -e " ${g}〄> ${c}${options[$i]} ${g}<〄${n}"
            else
                echo -e "     ${options[$i]}"
            fi
        done
    }

    while true; do
        display_menu

        read -rsn1 input

        if [[ "$input" == $'\e' ]]; then
            read -rsn2 -t 0.1 input
            case "$input" in
                '[A')
                    ((selected--))
                    if [ $selected -lt 0 ]; then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                '[B')
                    ((selected++))
                    if [ $selected -ge ${#options[@]} ]; then
                        selected=0
                    fi
                    ;;
                *)
                    display_menu
                    ;;
            esac
        elif [[ "$input" == "" ]]; then
            case ${options[$selected]} in
                "Free Usage")
                    echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Continue Free..!${n}"
                    sleep 1
                    setupx
                    ;;
                "Premium")
                    echo -e "\n ${g}[${n}${HOST}${g}] ${c}Wait for opening Telegram..!${n}"
                    sleep 1
                    xdg-open "https://t.me/badhon_6t9_x"
                    cd "$HOME"
                    rm -rf BADHON 2>/dev/null
                    exit 0
                    ;;
            esac
        fi
    done
}

# Start the script
help
main_menu
