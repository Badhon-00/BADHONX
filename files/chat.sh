#!/bin/bash

# Clear screen and check for dependencies
clear
if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    pkg install curl -y &> /dev/null
fi

if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    pkg install jq -y &> /dev/null
fi

clear

# Color definitions
r='\033[1;91m'  # red
p='\033[1;95m'  # pink
y='\033[1;93m'  # yellow
g='\033[1;92m'  # green
n='\033[1;0m'   # normal
b='\033[1;94m'  # blue
c='\033[1;96m'  # cyan

# Symbols
X='\033[1;92m[\033[1;00m⎯꯭̽𓆩\033[1;92m]\033[1;96m'
D='\033[1;92m[\033[1;00m〄\033[1;92m]\033[1;93m'
E='\033[1;92m[\033[1;00m×\033[1;92m]\033[1;91m'
A='\033[1;92m[\033[1;00m+\033[1;92m]\033[1;92m'
C='\033[1;92m[\033[1;00m</>\033[1;92m]\033[92m'
lm='\033[1;96m▱▱▱▱▱▱\033[1;0m〄\033[1;96m▱▱▱▱▱▱\033[1;00m'
dm='\033[1;93m▱▱▱▱▱▱\033[1;0m〄\033[1;93m▱▱▱▱▱▱\033[1;00m'

# Configuration
URL="https://badhonx-chat-hew1.onrender.com"
USERNAME_DIR="$HOME/.BADHONX"
USERNAME_FILE="$USERNAME_DIR/usernames.txt"
random_number=$(( RANDOM % 2 ))

# Create directory if it doesn't exist
mkdir -p "$USERNAME_DIR"

# Function to check internet connection
inter() {
    clear
    echo
    echo -e "               ${g}╔═══════════════╗"
    echo -e "               ${g}║ ${n}</>  ${c}BADHON-X${g} ║"
    echo -e "               ${g}╚═══════════════╝"
    echo -e "  ${g}╔════════════════════════════════════════════╗"
    echo -e "  ${g}║  ${C} ${y}Checking Your Internet Connection¡${g}  ║"
    echo -e "  ${g}╚════════════════════════════════════════════╝${n}"
    
    local max_attempts=5
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl --silent --head --connect-timeout 10 --max-time 15 "https://github.com" > /dev/null 2>&1; then
            break
        else
            echo -e "              ${g}╔══════════════════╗"
            echo -e "              ${g}║${C} ${r}No Internet (Attempt $attempt/$max_attempts) ${g}║"
            echo -e "              ${g}╚══════════════════╝"
            sleep 2.5
            ((attempt++))
        fi
    done
    
    if [ $attempt -gt $max_attempts ]; then
        echo -e "\n${E} ${r}Failed to connect to internet. Please check your connection.${n}"
        exit 1
    fi
    clear
}

# Loading animation
load() {
    clear
    echo -e " ${r}●${n}"
    sleep 0.2
    clear
    echo -e " ${r}●${y}●${n}"
    sleep 0.2
    clear
    echo -e " ${r}●${y}●${b}●${n}"
    sleep 0.2
    clear
}

# Function to safely parse JSON with jq
safe_json_parse() {
    local json_data="$1"
    local jq_filter="$2"
    
    if [ -z "$json_data" ] || [ "$json_data" = "null" ] || [ "$json_data" = "[]" ]; then
        return 1
    fi
    
    echo "$json_data" | jq -r "$jq_filter" 2>/dev/null || return 1
}

# Function to check warnings
check_warnings() {
    local response
    response=$(curl -s --connect-timeout 10 "$URL/warnings" 2>/dev/null)
    
    if [ -n "$response" ] && [ "$response" != "null" ]; then
        local warning
        warning=$(safe_json_parse "$response" ".[] | select(.username == \"$username\") | \"Are You Warned — °|\\(.username)|°  \\(.warning)\"")
        
        if [ -n "$warning" ] && [ "$warning" != "null" ]; then
            echo -e "         ${r}$warning${n}"
            return 0
        fi
    fi
    return 1
}

# Function to check if user is banned
check_ban() {
    local response
    response=$(curl -s --connect-timeout 10 "$URL/ban" 2>/dev/null)
    
    if [ -n "$response" ] && [ "$response" != "null" ]; then
        local banned
        banned=$(safe_json_parse "$response" ".[] | select(.username == \"$username\") | \"Are You banned — °|\\(.username)|°  \\(.bn_mesg)\"")
        
        if [ -n "$banned" ] && [ "$banned" != "null" ]; then
            load
            echo -e "     ${c}____    __    ____  _  _     _  _ "
            echo -e "    ${c}(  _ \  /__\  (  _ \( )/ )___( \/ )"
            echo -e "    ${y} )(_) )/(__)\  )   / )  ((___))  ("
            echo -e "   ${y} (____/(__)(__)(_)\_)(_)\_)   (_/\_)\n"
            echo -e "         ${r}$banned${n}"
            echo
            return 0
        fi
    fi
    return 1
}

# Function to fetch messages
fetch_messages() {
    local response
    response=$(curl -s --connect-timeout 10 "$URL/messages" 2>/dev/null)
    
    if [ -n "$response" ] && [ "$response" != "null" ]; then
        safe_json_parse "$response" '.[] | "\(.username): \(.message)"' 2>/dev/null
    fi
}

# Function to fetch ads
fetch_ads() {
    local response
    response=$(curl -s --connect-timeout 10 "$URL/ads" 2>/dev/null)
    
    if [ -n "$response" ] && [ "$response" != "null" ]; then
        safe_json_parse "$response" '.[]' 2>/dev/null
    fi
}

# Function to send message
send_message() {
    local message="$1"
    local payload="{\"username\":\" 〄 $username\", \"message\":\"$message\"}"
    
    curl -s -X POST -H "Content-Type: application/json" -d "$payload" \
         --connect-timeout 10 "$URL/send" > /dev/null 2>&1 &
}

# Broken animation
broken() {
    clear
    for i in {1..6}; do
        case $i in
            1)
                echo -e "${c}        _(\___/)"
                echo -e "      =( ´ ${g}•⁠${p}ω${g}• ⁠${c})=   ˖<💌>."
                echo -e "      // ͡     )︵)"
                echo -e "     (⁠人_____づ_づ"
                ;;
            2)
                echo -e "${c}        _(\___/)"
                echo -e "      =( ´ ${g}•⁠${p}ω${g}• ⁠${c})=   𖥔˖<💘>.𖥔"
                echo -e "      // ͡     )︵)"
                echo -e "     (⁠人_____づ_づ"
                ;;
            3)
                echo -e "${c}        _(\___/)"
                echo -e "      =( ´ ${g}•⁠${p}ω${g}• ⁠${c})=   .𖥔 ˖<💘>.𖥔 ݁"
                echo -e "      // ͡     )︵)"
                echo -e "     (⁠人_____づ_づ"
                ;;
            4)
                echo -e "${c}        _(\___/)"
                echo -e "      =( ´ ${g}•⁠${p}ω${g}• ⁠${c})=   𖥔 ݁ ˖<💛>.𖥔 ݁ "
                echo -e "      // ͡     )︵)"
                echo -e "     (⁠人_____づ_づ"
                ;;
            5)
                echo -e "${c}        _(\___/)"
                echo -e "      =( ´ ${g}•⁠${p}ω${g}• ⁠${c})=   .𖥔 ݁ ˖<💗>.𖥔 ݁ ˖"
                echo -e "      // ͡     )︵)"
                echo -e "     (⁠人_____づ_づ"
                ;;
            6)
                echo -e "${c}        _(\___/)"
                echo -e "      =( ´ ${g}•⁠${p}ω${g}• ⁠${c})=   ₊ଳ ‧₊˚ ⋅.𖥔 ݁ ˖<💔>.𖥔 ݁ ˖⋅˚₊‧ ଳ₊"
                echo -e "      // ͡     )︵)"
                echo -e "     (⁠人_____づ_づ"
                ;;
        esac
        echo
        sleep 0.5
        clear
    done
    echo -e " ${C} ${g}Goodbye! ${y}(${c}-${r}.${c}-${y})${c}Zzz・・・・𑁍ࠬܓ"
    echo
    exit 0
}

# Goodbye animation
goodbye() {
    clear
    for i in {1..6}; do
        case $i in
            1|3|5)
                echo -e "${c}     ࿔‧ ֶָ֢˚˖𐦍˖˚ֶָ֢ ‧࿔       ╱|、"
                echo -e "                      (${b}˚${p}ˎ ${b}。${c}7"
                echo -e "                       |、~〵"
                echo -e "                       じしˍ,)⼃"
                ;;
            2|4|6)
                echo -e "${c}      ࿔‧ ֶָ֢˚˖𐦍˖˚ֶָ֢ ‧࿔      ╱|、"
                echo -e "                      (${b}˚${p}ˎ ${b}。${c}7"
                echo -e "                       |、~〵"
                echo -e "                       じしˍ,)ノ"
                ;;
        esac
        echo
        sleep 0.5
        clear
    done
    echo -e " ${C} ${g}Goodbye! ${y}(${c}-${r}.${c}-${y})${c}Zzz・・・・ཐི|ཋྀ"
    echo
    exit 0
}

# Instructions screen
dx() {
    clear
    echo
    echo -e " ${p}■ ${g}Use Tools ${p}▪︎${n}"
    echo
    echo -e " ${y}Enter ${g}q ${y}to Exit Tool${n}"
    echo
    echo -e "             q"
    echo
    echo -e " ${b}■ ${c}If you understand, press Enter to continue ${b}▪︎${n}"
    read -p ""
}

# Main chat display function
display_messages() {
    clear
    
    # Check if user is banned
    if check_ban; then
        exit 0
    fi
    
    load
    
    while true; do
        clear
        echo -e " ${r}●${y}●${b}●${n}"
        
        # Check for warnings
        check_warnings
        
        # Display header with date and time
        D=$(date +"${c}%Y-%b-%d${n}")
        T=$(date +"${c}%I:%M %p${n}")
        echo -e "${lm}"
        echo -e " $D"
        echo -e "  ${c}┏┓┓┏┏┓┏┳┓"
        echo -e "  ${c}┃ ┣┫┣┫ ┃               ${C} ${g}t.me/BadhonX_369"
        echo -e "  ${c}┗┛┛┗┛┗ ┻"
        echo -e "  $T"
        echo -e "${lm}"

        # Fetch and display messages
        local messages
        messages=$(fetch_messages)
        if [ -n "$messages" ]; then
            echo -e "${g}$messages${n}"
        else
            echo -e "${y}No messages yet...${n}"
        fi
        
        # Fetch and display ads
        local ads
        ads=$(fetch_ads)
        if [ -n "$ads" ]; then
            echo -e "\n${c}$ads${n}"
        fi

        echo -e "\n${dm}"
        
        # Get user input
        read -p "[+]─[Enter Message | $username]──➤ " message
        
        # Handle exit command
        if [[ "$message" == "q" ]] || [[ "$message" == "exit" ]]; then
            echo
            echo -e "\n ${E} ${r}Exiting Tool..!${n}"
            sleep 1
            if [ $random_number -eq 0 ]; then
                goodbye
            else
                broken
            fi
            break
        elif [[ -z "$message" ]]; then
            continue
        else
            # Send message
            send_message "$message"
        fi
    done
}

# Save username function
save_username() {
    clear
    load
    echo -e "        ${c}____    __    ____  _  _     _  _ "
    echo -e "       ${c}(  _ \  /__\  (  _ \( )/ )___( \/ )"
    echo -e "       ${y} )(_) )/(__)\  )   / )  ((___))  ("
    echo -e "      ${y} (____/(__)(__)(_)\_)(_)\_)   (_/\_)\n\n"
    echo -e " ${A} ${c}Enter Your Anonymous ${g}Username${c}"
    echo
    
    while true; do
        read -p "[+]──[Enter Your Username]────► " username
        
        # Validate username
        if [[ -z "$username" ]]; then
            echo -e "${E} ${r}Username cannot be empty!${n}"
            continue
        elif [[ "$username" =~ [^a-zA-Z0-9_-] ]]; then
            echo -e "${E} ${r}Username can only contain letters, numbers, hyphens and underscores!${n}"
            continue
        else
            break
        fi
    done

    sleep 1
    clear
    echo
    echo -e "		        ${g}Hey ${y}$username${n}"
    echo -e "${c}              (\_/)"
    echo -e "              (${y}^ω^${c})     ${g}I'm BadhonX${c}"
    echo -e "             ⊂(___)づ  ⋅˚₊‧ ଳ ‧₊˚ ⋅"
    echo
    echo -e " ${A} ${c}Your account created ${g}Successfully¡${c}"
    
    # Save the username
    echo "$username" > "$USERNAME_FILE"
    echo
    sleep 1
    echo -e " ${D} ${c}Enjoy Our Chat Tool¡${n}"
    echo
    read -p "[+]──[Press Enter to continue]────► "
    dx
    display_messages
}

# Main execution flow
main() {
    # Load username if exists, otherwise create new
    if [ -f "$USERNAME_FILE" ]; then
        username=$(cat "$USERNAME_FILE" 2>/dev/null)
        if [ -z "$username" ]; then
            save_username
        fi
    else
        save_username
    fi
    
    # Check internet and start chat
    inter
    display_messages
}

# Run main function
main
