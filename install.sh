#!/bin/bash

clear

# badhonx color
r='\033[1;91m'
p='\033[1;95m'
y='\033[1;93m'
g='\033[1;92m'
n='\033[1;0m'
b='\033[1;94m'
c='\033[1;96m'

# badhonx Symbol
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# badhonx icon
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

# System variables
MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
VENDOR=$(getprop ro.product.manufacturer 2>/dev/null || echo "Unknown")
devicename="${VENDOR} ${MODEL}"
THRESHOLD=100
random_number=$(( RANDOM % 2 ))
SHELL=$(basename "$SHELL")

# Define missing variables
badhon="$HOME/.termux/colors.properties"

# Function to handle script exit
exit_script() {
    clear
    echo
    echo
    echo -e ""
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^_^${c})     ${A} ${g}Hey dear${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"              
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}Badhonx Banner \033[1;36m"
    echo
    cd "$HOME" || exit 1
    rm -rf "$HOME/BADHONX" 2>/dev/null
    exit 0
}

trap exit_script SIGINT SIGTSTP

check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size
    local used_size
    local disk_usage

    # Get disk usage information
    if df -h "$HOME" >/dev/null 2>&1; then
        total_size=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $2}')
        used_size=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $3}')
        disk_usage=$(df "$HOME" 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//g')
    else
        total_size="Unknown"
        used_size="Unknown"
        disk_usage="0"
    fi

    # Check if the disk usage exceeds the threshold
    if [ "$disk_usage" -ge "$threshold" ] 2>/dev/null; then
        echo -e "${g}[${n}\uf0a0${g}] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
    fi
}

sp() {
    IFS=''
    sentence=$1
    second=${2:-0.05}
    for (( i=0; i<${#sentence}; i++ )); do
        char=${sentence:$i:1}
        echo -n "$char"
        sleep "$second"
    done
    echo
}

# Create directory if it doesn't exist
mkdir -p "$HOME/.Badhonx-shanto"

tr() {
    # Check if curl is installed
    if ! command -v curl &>/dev/null; then
        pkg install curl -y >/dev/null 2>&1
    fi
    
    # Check if ncurses-utils is installed
    if ! pkg list-installed | grep -q "ncurses-utils"; then
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
    read -p ""
}

spin() {
    echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    # Function to show the spinner while a command is running
    show_spinner() {
        local pid=$!
        local package_name=$1
        while ps -p "$pid" > /dev/null 2>&1; do
            for i in "${spinner[@]}"; do
                tput civis 2>/dev/null
                echo -ne "\033[1;96m\r [+] Installing $package_name please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep "$delay"
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm 2>/dev/null
        printf "\e[1;93m [Done $package_name]\e[0m\n"
        echo
        sleep 1
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    
    # List of packages to install
    packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")

    # Install each package with spinner
    for package in "${packages[@]}"; do
        if pkg install "$package" -y >/dev/null 2>&1 & then
            show_spinner "$package"
        else
            echo -e " ${E} Failed to install $package"
        fi
    done

    # Additional installations
    if pip install lolcat >/dev/null 2>&1; then
        echo -e " ${A} ${g}lolcat installed successfully${n}"
    fi
    
    # Clean up and move files
    rm -rf "$HOME/data/data/com.termux/files/usr/bin/chat" 2>/dev/null
    mkdir -p "$HOME/.Badhonx-simu"
    mv "$HOME/BADHONX/files/report" "$HOME/.Badhonx-simu/" 2>/dev/null
    mkdir -p "/data/data/com.termux/files/usr/bin"
    mv "$HOME/BADHONX/files/chat.sh" "/data/data/com.termux/files/usr/bin/chat" 2>/dev/null
    chmod +x "/data/data/com.termux/files/usr/bin/chat" 2>/dev/null
    
    # Install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" >/dev/null 2>&1
    fi
    
    rm -rf "/data/data/com.termux/files/usr/etc/motd" 2>/dev/null
    chsh -s zsh 2>/dev/null
    rm -rf "$HOME/.zshrc" 2>/dev/null
    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$HOME/.zshrc" 2>/dev/null
    
    # Install zsh plugins
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" >/dev/null 2>&1
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" >/dev/null 2>&1
    fi
    
    # Install gem lolcat
    if echo "y" | gem install lolcat > /dev/null 2>&1; then
        echo -e " ${A} ${g}gem lolcat installed successfully${n}"
    fi
}

# badhonx setup
setup() {
    # Create termux directory if it doesn't exist
    ds="$HOME/.termux"
    dx="$ds/font.ttf"
    mkdir -p "$ds"
    
    # Copy font file if it doesn't exist
    if [ ! -f "$dx" ]; then
        cp "$HOME/BADHONX/files/font.ttf" "$ds/" 2>/dev/null
    fi

    # Copy colors properties if it doesn't exist
    if [ ! -f "$badhon" ]; then
        cp "$HOME/BADHONX/files/colors.properties" "$ds/" 2>/dev/null
    fi
    
    # Copy figlet font
    mkdir -p "$PREFIX/share/figlet/"
    cp "$HOME/BADHONX/files/ASCII-Shadow.flf" "$PREFIX/share/figlet/" 2>/dev/null
    
    # Move remove script
    mkdir -p "/data/data/com.termux/files/usr/bin"
    mv "$HOME/BADHONX/files/remove" "/data/data/com.termux/files/usr/bin/" 2>/dev/null
    chmod +x "/data/data/com.termux/files/usr/bin/remove" 2>/dev/null
    
    termux-reload-settings 2>/dev/null
}

badhonxnetcheck() {
    clear
    echo
    echo -e "               ${g}╔═══════════════╗"
    echo -e "               ${g}║ ${n}</>  ${c}BADHONX${g}   ║"
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

    # Loop to prompt until valid name (1-8 characters)
    while true; do
        read -rp "[+]──[Enter Your Name]────► " name
        echo

        # Validate name length (must be 1-8 characters)
        if [[ ${#name} -ge 1 && ${#name} -le 8 ]]; then
            break  # Valid, proceed
        else
            echo -e " ${E} ${r}Name must be between ${g}1 and 8${r} characters. ${y}Please try again.${c}"
            echo
        fi
    done

    # Specify directories and files
    D1="$HOME/.termux"
    USERNAME_FILE="$D1/usernames.txt"
    VERSION="$D1/bx.txt"
    INPUT_FILE="$HOME/BADHONX/files/.zshrc"
    THEME_INPUT="$HOME/BADHONX/files/.badhonx.zsh-theme"
    OUTPUT_ZSHRC="$HOME/.zshrc"
    OUTPUT_THEME="$HOME/.oh-my-zsh/themes/badhonx.zsh-theme"
    TEMP_FILE="$HOME/temp.zshrc"

    # Create directories if they don't exist
    mkdir -p "$D1"
    mkdir -p "$HOME/.oh-my-zsh/themes"

    # Use sed to replace BADHON with the name and save to temporary file
    if sed "s/BADHON/$name/g" "$INPUT_FILE" > "$TEMP_FILE" 2>/dev/null &&
       sed "s/BADHON/$name/g" "$THEME_INPUT" > "$OUTPUT_THEME" 2>/dev/null &&
       echo "$name" > "$USERNAME_FILE" &&
       echo "version 1.5" > "$VERSION"; then

        # Move the temporary file to the original output
        mv "$TEMP_FILE" "$OUTPUT_ZSHRC" 2>/dev/null
        clear
        echo
        echo
        echo -e "		        ${g}Hey ${y}$name"
        echo -e "${c}              (\_/)"
        echo -e "              (${y}^ω^${c})     ${g}I'm Badhonx${c}"
        echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
        echo
        echo -e " ${A} ${c}Your Banner created ${g}Successfully¡${c}"
        echo
        sleep 3
    else
        echo
        echo -e " ${E} ${r}Error occurred while processing the file."
        sleep 1
        # Clean up temporary file if sed fails
        rm -f "$TEMP_FILE"
    fi

    echo
    clear
}

banner() {
    echo
    echo
    echo -e "   ${y}██████╗░░█████╗░██████╗░██╗░░██╗░█████╗░███╗░░██╗██╗░░██╗"
    echo -e "   ${y}██╔══██╗██╔══██╗██╔══██╗██║░░██║██╔══██╗████╗░██║╚██╗██╔╝"
    echo -e "   ${y}██████╦╝███████║██║░░██║███████║██║░░██║██╔██╗██║░╚███╔╝░"
    echo -e "   ${c}██╔══██╗██╔══██║██║░░██║██╔══██║██║░░██║██║╚████║░██╔██╗░"
    echo -e "   ${c}██████╦╝██║░░██║██████╔╝██║░░██║╚█████╔╝██║░╚███║██╔╝╚██╗"
    echo -e "   ${c}╚═════╝░╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝${n}"
    echo -e "${y}               +-+-+-+-+-+-+-+-+"
    echo -e "${c}               |B|A|D|H|O|N|X|"
    echo -e "${y}               +-+-+-+-+-+-+-+-+${n}"
    echo
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/badhon_6t9_x"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/badhon_6t9_x"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    echo
    echo -e "${b}╭══ ${g}〄 ${y}ʙᴀᴅʜᴏɴx ${g}〄"
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
        badhonxnetcheck
        
        banner
        echo -e " ${C} ${y}Detected Termux on Android¡"
        echo -e " ${lm}"
        echo -e " ${A} ${g}Updating Package..¡"
        echo -e " ${dm}"
        echo -e " ${A} ${g}Wait a few minutes.${n}"
        echo -e " ${lm}"
        termux
        
        # badhonx check if BADHONX folder exists
        if [ -d "$HOME/BADHONX" ]; then
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
            cd "$HOME" || exit 1
            rm -rf "$HOME/BADHONX" 2>/dev/null
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
    echo
    echo
    echo -e "   ${y}██████╗░░█████╗░██████╗░██╗░░██╗░█████╗░███╗░░██╗██╗░░██╗"
    echo -e "   ${y}██╔══██╗██╔══██╗██╔══██╗██║░░██║██╔══██╗████╗░██║╚██╗██╔╝"
    echo -e "   ${y}██████╦╝███████║██║░░██║███████║██║░░██║██╔██╗██║░╚███╔╝░"
    echo -e "   ${c}██╔══██╗██╔══██║██║░░██║██╔══██║██║░░██║██║╚████║░██╔██╗░"
    echo -e "   ${c}██████╦╝██║░░██║██████╔╝██║░░██║╚█████╔╝██║░╚███║██╔╝╚██╗"
    echo -e "   ${c}╚═════╝░╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚═╝░░╚═╝${n}"
    echo -e "${y}               +-+-+-+-+-+-+-+-+"
    echo -e "${c}               |B|A|D|H|O|N|X|"
    echo -e "${y}               +-+-+-+-+-+-+-+-+${n}"
    echo
    if [ $random_number -eq 0 ]; then
        echo -e "${b}╭════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/badhon_6t9_x"
        echo -e "${b}╰════════════════════════⊷"
    else
        echo -e "${b}╭══════════════════════════⊷"
        echo -e "${b}┃ ${g}[${n}ム${g}] ᴛɢ: ${y}t.me/badhon_6t9_x"
        echo -e "${b}╰══════════════════════════⊷"
    fi
    echo
    echo -e "${b}╭══ ${g}〄 ${y}ʙᴀᴅʜᴏɴx ${g}〄"
    echo -e "${b}┃❁ ${g}ᴄʀᴇᴀᴛᴏʀ: ${y}-ʙᴀᴅʜᴏɴ"
    echo -e "${b}╰┈➤ ${g}Hey ${y}Dear"
    echo
    echo -e "${c}╭════════════════════════════════════════════════⊷"
    echo -e "${c}┃ ${p}❏ ${g}Choose what you want to use. then Click Enter${n}"
    echo -e "${c}╰════════════════════════════════════════════════⊷"
}

# Main menu function
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

    # Main loop
    while true; do
        display_menu

        # Read a single character input with no echo
        read -rsn1 input

        # Handle escape sequences for arrow keys
        if [[ "$input" == $'\e' ]]; then
            read -rsn2 -t 0.1 input
            case "$input" in
                '[A') # Up arrow
                    ((selected--))
                    if [ $selected -lt 0 ]; then
                        selected=$((${#options[@]} - 1))
                    fi
                    ;;
                '[B') # Down arrow
                    ((selected++))
                    if [ $selected -ge ${#options[@]} ]; then
                        selected=0
                    fi
                    ;;
                *) # Ignore other escape sequences
                    display_menu
                    ;;
            esac
        elif [[ "$input" == "" ]]; then # Enter key
            case ${options[$selected]} in
                "Free Usage")
                    echo -e "\n ${g}[${n}${HOMES}${g}] ${c}Continue Free..!${n}"
                    sleep 1
                    setupx
                    ;;
                "Premium")
                    echo -e "\n ${g}[${n}${HOST}${g}] ${c}Wait for opening Telegram..!${n}"
                    sleep 1
                    xdg-open "https://t.me/badhon_6t9_x" 2>/dev/null || \
                    am start -a android.intent.action.VIEW -d "https://t.me/badhon_6t9_x" 2>/dev/null || \
                    echo -e " ${E} ${r}Could not open browser. Please visit: https://t.me/badhon_6t9_x"
                    cd "$HOME" || exit 1
                    rm -rf "$HOME/BADHONX" 2>/dev/null
                    exit 0
                    ;;
            esac
        fi
    done
}

# Start the script
help
main_menu
