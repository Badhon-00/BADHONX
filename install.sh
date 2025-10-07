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
MODEL=$(getprop ro.product.model)
VENDOR=$(getprop ro.product.manufacturer)
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
    echo -e "\n ${g}[${n}${KER}${g}] ${c}Exiting ${g}Badhonx Banner \033[1;36m"
    echo
    cd "$HOME"
    rm -rf BADHONX
    exit 0
}

trap exit_script SIGINT SIGTSTP
check_disk_usage() {
    local threshold=${1:-$THRESHOLD}  # Use passed argument or default to THRESHOLD
    local total_size
    local used_size
    local disk_usage

    # Get total size, used size, and disk usage percentage for the home directory
    total_size=$(df -h "$HOME" | awk 'NR==2 {print $2}')
    used_size=$(df -h "$HOME" | awk 'NR==2 {print $3}')
    disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//g')

    # Check if the disk usage exceeds the threshold
    if [ "$disk_usage" -ge "$threshold" ]; then
        echo -e "${g}[${n}\uf0a0${g}] ${r}WARN: ${y}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e "${y}Disk usage: ${g}${disk_usage}% ${c}| ${g}${used_size}"
    fi
}
data=$(check_disk_usage)
sp() {
    IFS=''
    sentence=$1
    second=${2:-0.05}
    for (( i=0; i<${#sentence}; i++ )); do
        char=${sentence:$i:1}
        echo -n "$char"
        sleep $second
    done
    echo
}
mkdir -p .Badhonx-shanto
tr() {
# Check if curl is installed
if command -v curl &>/dev/null; then
    echo ""
else
    pkg install curl -y &>/dev/null 2>&1
fi
if command -v ncurses-utils -y &>/dev/null; then
    echo ""
else
    pkg install ncurses-utils -y >/dev/null 2>&1
fi
}
help() {
clear
echo
echo -e " ${p}■ \e[4m${g}Use Button\e[4m ${p}▪︎${n}"
    echo
echo -e " ${y}Use Termux Extra key Button${n}"
echo
echo -e " UP          ↑"
echo -e " DOWN        ↓"
echo
echo -e " ${g}Select option Click Enter button"
echo
echo -e " ${b}■ \e[4m${c}If you understand, click the Enter Button\e[4m ${b}▪︎${n}"
read -p ""
}
help
spin() {
echo
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    # Function to show the spinner while a command is running
    show_spinner() {
        local pid=$!
        while ps -p $pid > /dev/null; do
            for i in "${spinner[@]}"; do
                tput civis
                echo -ne "\033[1;96m\r [+] Installing $1 please wait \e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
                sleep $delay
                printf "\b\b\b\b\b\b\b\b"
            done
        done
        printf "   \b\b\b\b\b"
        tput cnorm
        printf "\e[1;93m [Done $1]\e[0m\n"
        echo
        sleep 1
    }

    apt update >/dev/null 2>&1
    apt upgrade -y >/dev/null 2>&1
    # List of packages to install
    packages=("git" "python" "ncurses-utils" "jq" "figlet" "termux-api" "lsd" "zsh" "ruby" "exa")

    # Install each package with spinner
    for package in "${packages[@]}"; do
        pkg install "$package" -y >/dev/null 2>&1 &
        show_spinner "$package"
    done

pip install lolcat >/dev/null 2>&1
rm -rf data/data/com.termux/files/usr/bin/chat >/dev/null 2>&1
mv $HOME/BADHONX/files/report $HOME/.Badhonx-simu
mv $HOME/BADHONX/files/chat.sh /data/data/com.termux/files/usr/bin/chat
chmod +x /data/data/com.termux/files/usr/bin/chat
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh >/dev/null 2>&1
rm -rf /data/data/com.termux/files/usr/etc/motd
chsh -s zsh
rm -rf ~/.zshrc >/dev/null 2>&1
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-autosuggestions >/dev/null 2>&1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /data/data/com.termux/files/home/.oh-my-zsh/plugins/zsh-syntax-highlighting >/dev/null 2>&1
echo "y" | gem install lolcat > /dev/null
}
# badhonx setup
setup() {
# badhonx move
ds="$HOME/.termux"
dx="$ds/font.ttf"
simu="$ds/colors.properties"
if [ -f "$dx" ]; then
    echo
else
	cp $HOME/BADHONX/files/font.ttf "$ds"
fi

if [ -f "$badhon" ]; then
    echo
else 
        
	cp $HOME/BADHONX/files/colors.properties "$ds"
fi
cp $HOME/BADHONX/files/ASCII-Shadow.flf $PREFIX/share/figlet/
mv $HOME/BADHONX/files/remove /data/data/com.termux/files/usr/bin/
chmod +x /data/data/com.termux/files/usr/bin/remove
termux-reload-settings
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
    curl --silent --head --fail https://github.com > /dev/null
    if [ "$?" != 0 ]; then
echo -e "              ${g}╔══════════════════╗"
echo -e "              ${g}║${C} ${r}No Internet ${g}║"
echo -e "              ${g}╚══════════════════╝"
        sleep 2.5
    else
        break
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
        read -p "[+]──[Enter Your Name]────► " name
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
    TEMP_FILE="$HOME/temp.zshrc"  # Actual temporary file

    # Use sed to replace SIMU with the name and save to temporary file
    sed "s/BADHON/$name/g" "$INPUT_FILE" > "$TEMP_FILE" &&
    sed "s/BADHON/$name/g" "$THEME_INPUT" > "$OUTPUT_THEME" &&
    echo "$name" > "$USERNAME_FILE" &&
    echo "version 1.5" > "$VERSION"  # Fixed version string

    # Check if all operations were successful
    if [[ $? -eq 0 ]]; then
        # Move the temporary file to the original output
        mv "$TEMP_FILE" "$OUTPUT_ZSHRC"
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
	cd "$HOME"
	rm -rf BADHONX
	exit 0
	    else
        clear
        banner
    echo -e " ${E} ${r}Tools Not Exits Your Terminal.."
	echo
	echo
	sleep 3
	exit
    fi
else
echo -e " ${E} ${r}Sorry, this operating system is not supported ${p}| ${g}[${n}${HOST}${g}] ${SHELL}${n}"
echo 
echo -e " ${A} ${g} Wait for the next update using Linux...!¡"
    echo
	sleep 3
	exit
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
                xdg-open "https://t.me/badhon_6t9_x"
                cd "$HOME"
            	rm -rf BADHONX
                exit 0
                ;;
        esac
    fi
done
