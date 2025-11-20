ZSH_THEME="badhon"
export ZSH=$HOME/.oh-my-zsh
plugins=(git)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Source plugins if they exist
[ -f "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

[ -f "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

alias ls='lsd -lh --blocks size,name 2>/dev/null || ls -lh'
alias rd='termux-reload-settings 2>/dev/null'

clear

# Color definitions
r='\033[91m'
p='\033[1;95m'
y='\033[93m'
g='\033[92m'
n='\033[0m'
b='\033[94m'
c='\033[96m'

# Symbol definitions
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;32m]\033[1;92m'
lm='\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[96m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'
dm='\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[0m〄\033[93m▱▱▱▱▱▱▱▱▱▱▱▱\033[1;00m'

# Icon definitions
aHELL="\uf489"
USER="\uf007"
TERMINAL="\ue7a2"
PKGS="\uf8d6"
UPT="\uf49b"
CAL="\uf073"

bol='\033[1m'
bold="${bol}\e[4m"
THRESHOLD=100

# Disk usage function with error handling
check_disk_usage() {
    local threshold=${1:-$THRESHOLD}
    local total_size
    local used_size
    local disk_usage

    if command -v df >/dev/null 2>&1; then
        total_size=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $2}' || echo "Unknown")
        used_size=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $3}' || echo "Unknown")
        disk_usage=$(df "$HOME" 2>/dev/null | awk 'NR==2 {print $5}' | sed 's/%//g' 2>/dev/null || echo "0")
    else
        total_size="Unknown"
        used_size="Unknown"
        disk_usage="0"
    fi

    # Ensure disk_usage is numeric
    if ! [[ "$disk_usage" =~ ^[0-9]+$ ]]; then
        disk_usage=0
    fi

    if [ "$disk_usage" -ge "$threshold" ] 2>/dev/null; then
        echo -e " ${g}[${n}\uf0a0${g}] ${r}WARN: ${c}Disk Full ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    else
        echo -e " ${g}[${n}\uf0e7${g}] ${c}Disk usage: ${g}${disk_usage}% ${c}| ${c}U${g}${used_size} ${c}of ${c}T${g}${total_size}"
    fi
}

data=$(check_disk_usage)

# Spinner function with error handling
spin() {
    clear
    banner
    local pid=$1
    local delay=0.40
    local spinner=('█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█')

    while ps -p $pid >/dev/null 2>&1; do
        for i in "${spinner[@]}"; do
            tput civis 2>/dev/null
            echo -ne "\033[1;96m\r [+] Downloading..please wait.........\e[33m[\033[1;92m$i\033[1;93m]\033[1;0m   "
            sleep $delay
            printf "\b\b\b\b\b\b\b\b" 2>/dev/null
        done
    done
    printf "   \b\b\b\b\b" 2>/dev/null
    tput cnorm 2>/dev/null
    printf "\e[1;93m [Done]\e[0m\n"
    echo
    sleep 1
}

# Server URL - define properly or use fallback
BADHONX_SERVER="https://your-badhonx-server.vercel.app"
BADHON_SERVER="https://your-badhon-server.vercel.app"

cd $HOME || exit 1

D1="$HOME/.termux"
mkdir -p "$D1"
VERSION="$D1/bhx.txt"

if [ -f "$VERSION" ]; then
    version=$(cat "$VERSION" 2>/dev/null || echo "version 1.0")
else
    echo "version 1.0" > "$VERSION"
    version="version 1.0"
fi

# Banner function
banner() {
    clear
    echo
    echo -e "    ${y}██████╗░░█████╗░██████╗░██╗░░██╗░█████╗░███╗░░██╗"
    echo -e "    ${y}██╔══██╗██╔══██╗██╔══██╗██║░░██║██╔══██╗████╗░██║"
    echo -e "    ${y}██████╦╝███████║██║░░██║███████║██║░░██║██╔██╗██║"
    echo -e "    ${c}██╔══██╗██╔══██║██║░░██║██╔══██║██║░░██║██║╚████║"
    echo -e "    ${c}██████╦╝██║░░██║██████╔╝██║░░██║╚█████╔╝██║░╚███║"
    echo -e "    ${c}╚═════╝░╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝${n}"
    echo
}

# Update function with proper error handling
udp() {
    local messages=""
    
    # Check if curl and jq are available
    if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
        messages=$(curl -s --connect-timeout 5 "$BADHON_SERVER/check_version" 2>/dev/null | \
                  jq -r --arg vs "$version" '.[] | select(.message == $vs) | .message' 2>/dev/null)
    fi

    if [ -n "$messages" ]; then
        banner
        echo -e " ${A} ${c}Tools Updated ${n}| ${c}New ${g}$version"
        sleep 3
        if command -v git >/dev/null 2>&1; then
            git clone https://github.com/your-username/BADHON.git &>/dev/null &
            local clone_pid=$!
            spin $clone_pid
            wait $clone_pid
            if [ -d "BADHONX" ]; then
                cd BADHONX || return
                [ -f "install.sh" ] && bash install.sh
            fi
        else
            echo -e " ${E} ${r}Git not available for update${n}"
        fi
    else
        clear
    fi
}

# Loading animation
load() {
    clear
    echo -e "${TERMINAL}${r}●${n}"
    sleep 0.2
    clear
    echo -e "${TERMINAL}${r}●${y}●${n}"
    sleep 0.2
    clear
    echo -e "${TERMINAL}${r}●${y}●${b}●${n}"
    sleep 0.2
}

# Terminal display functions with error handling
PUT() { 
    local row=$1
    local col=$2
    echo -en "\033[${row};${col}H" 2>/dev/null
}

DRAW() { 
    echo -en "\033%" 2>/dev/null
    echo -en "\033(0" 2>/dev/null
}

WRITE() { 
    echo -en "\033(B" 2>/dev/null
}

HIDECURSOR() { 
    echo -en "\033[?25l" 2>/dev/null
}

NORM() { 
    echo -en "\033[?12l\033[?25h" 2>/dev/null
}

# Get terminal dimensions with fallback
get_terminal_size() {
    if command -v stty >/dev/null 2>&1; then
        stty size 2>/dev/null | awk '{print $2}'
    elif command -v tput >/dev/null 2>&1; then
        tput cols 2>/dev/null
    else
        echo "80"  # Default fallback
    fi
}

get_terminal_height() {
    if command -v stty >/dev/null 2>&1; then
        stty size 2>/dev/null | awk '{print $1}'
    elif command -v tput >/dev/null 2>&1; then
        tput lines 2>/dev/null
    else
        echo "24"  # Default fallback
    fi
}

# Main execution
udp
HIDECURSOR
load
clear

# Get terminal dimensions
width=$(get_terminal_size)
height=$(get_terminal_height)

# Create box elements with safe width calculation
var=$((width - 2))
if [ $var -lt 1 ]; then
    var=1
fi

var2=$(printf '%*s' $var '' | tr ' ' '═')
var3=$(printf '%*s' $var '')
var4=$((width - 20))
if [ $var4 -lt 1 ]; then
    var4=1
fi

# Display disk usage information
prefix="${TERMINAL}${r}●${y}●${b}●${n}"
clean_prefix=$(echo -e "$prefix" | sed 's/\x1b\[[0-9;]*m//g')
prefix_len=${#clean_prefix}
clean_data=$(echo -e "${data}" | sed 's/\x1b\[[0-9;]*m//g')
data_len=${#clean_data}
data_start=$(((width - data_len) / 2))
padding=$((data_start - prefix_len))
if [ $padding -lt 0 ]; then 
    padding=0
fi
spaces=$(printf '%*s' $padding "")

echo -e "${prefix}${spaces}${data}${n}"

# Draw the box
echo "╔${var2}╗"
for ((i=1; i<=8; i++)); do
    echo "║${var3}║"
done
echo "╚${var2}╝"

# Display figlet text if available
PUT 4 0
if command -v figlet >/dev/null 2>&1 && command -v lolcat >/dev/null 2>&1; then
    figlet -c -f ASCII-Shadow -w $width "BADHONX" 2>/dev/null | lolcat 2>/dev/null
else
    echo -e "${c}${bold}BADHONX${n}" | head -n 3
fi

# Draw vertical lines
PUT 3 0
echo -e "\033[36;1m"
for ((i=1; i<=7; i++)); do
    PUT $((3 + i)) 0
    echo "║"
    PUT $((3 + i)) $((width + 1))
    echo "║"
done

# Display version info
PUT 10 $var4
echo -e "\e[32m[\e[0m\uf489\e[32m] \e[36mBADHONX \e[36m1.0\e[0m"

# Display ads or date information
PUT 12 0
ads1=""
if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    ads1=$(curl -s --connect-timeout 3 "$BADHONX_SERVER/ads" 2>/dev/null | \
           jq -r '.[] | .message' 2>/dev/null)
fi

if [ -z "$ads1" ]; then
    DATE=$(date +"%Y-%b-%a ${g}—${c} %d" 2>/dev/null || echo "Unknown Date")
    TM=$(date +"%I:%M:%S ${g}— ${c}%p" 2>/dev/null || echo "Unknown Time")
    echo -e " ${g}[${n}${CAL}${g}] ${c}${TM} ${g}| ${c}${DATE}"
else
    echo -e " ${g}[${n}${PKGS}${g}] ${c}This is for you: ${g}$ads1"
fi

NORM
