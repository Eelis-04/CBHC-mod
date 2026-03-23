#!/bin/sh
# CBHC-mod v0.1 by Eelis-04
# Boot menu for postmarketOS and other distros
# Inspired by CBHC (Coldboot Haxchi) for Wii U
#Currently no features
#
# TEST VERSION — keyboard input (for Arch Linux dev/testing)
# Controls:
#   Arrow Up    — navigate up
#   Arrow Down  — navigate down
#   Enter       — confirm / select
#   q           — quit (testing only)

# ── Terminal setup ─────────────────────────────────────────────────────────────
export TERM=linux
clear

# ── Colors ─────────────────────────────────────────────────────────────────────
WHITE='\033[1;37m'
RESET='\033[0m'

# Black background, clear screen, cursor home
printf '\033[40m\033[2J\033[H'

# ── Config ─────────────────────────────────────────────────────────────────────
AUTOBOOT="Disabled"
VERSION="0.1"
AUTHOR="Eelis-04"
TOTAL=7

selected=0

# ── menu entries ───────────────────────────────────────────────────────────────
entry_0="Boot System Menu"
entry_1="Boot Loadiine"
entry_2="Boot Homebrew Launcher LX"
entry_3="Boot different DE"
entry_4="Boot fw.img from nand folder"
entry_5="Boot Different Kernel"
entry_6="Boot FTP ROOT"


get_entry() {
    eval "printf '%s' \"\$entry_$1\""
}

print_menu() {
    printf '\033[H'

    printf "${WHITE}CBHC Ver. %s by %s | (postmarketOS)${RESET}\n" "$VERSION" "$AUTHOR"
    printf "\n"

    # entries
    i=0
    while [ "$i" -lt "$TOTAL" ]; do
        label=$(get_entry "$i")
        if [ "$i" = "$selected" ]; then
            printf "${WHITE}  > %s${RESET}\n" "$label"
        else
            printf "    %s\n" "$label"
        fi
        i=$((i + 1))
    done

    # Autoboot status (not selectable atm)
    printf "\n"
    printf "    Autoboot: %s\n" "$AUTOBOOT"

    # Controls hint, may remove or keep, not sure yet
    printf "\n"
    printf "    Arrow Up/Down = navigate   Enter = select   q = quit\n"
}

# ── Boot actions ──────────────────────────────────────────────────────────────
boot_system_menu() {
    clear
    printf "${WHITE}Booting System Menu...${RESET}\n"
    exit 0
}

not_implemented() {
    clear
    printf "${WHITE}[ %s ]${RESET}\n" "$1"
    printf "Not yet implemented.\n\n"
    printf "Press Enter to return to menu...\n"
    read -r _
}

handle_selection() {
    case "$selected" in
        0) boot_system_menu ;;
        1) not_implemented "Boot Loadiine" ;;
        2) not_implemented "Boot Homebrew Launcher" ;;
        3) not_implemented "Boot different DE" ;;
        4) not_implemented "Boot fw.img from nand folder" ;;
        5) not_implemented "Boot Different Kernel" ;;
        6) not_implemented "Boot FTP ROOT" ;;
    esac
}

# ── Key reading ────────────────────────────────────────────────────────────────
read_key() {
    old_tty=$(stty -g)
    stty -echo -icanon min 1 time 0

    key=$(dd bs=1 count=1 2>/dev/null)

    if [ "$key" = "$(printf '\033')" ]; then
        seq1=$(dd bs=1 count=1 2>/dev/null)
        seq2=$(dd bs=1 count=1 2>/dev/null)
        key="${key}${seq1}${seq2}"
    fi

    stty "$old_tty"
    printf '%s' "$key"
}

# ──  Main loop
while true; do
    print_menu

    key=$(read_key)

    case "$key" in
        "$(printf '\033[A')")   # Arrow up
            selected=$((selected - 1))
            if [ "$selected" -lt 0 ]; then
                selected=$((TOTAL - 1))
            fi
            ;;
        "$(printf '\033[B')")   # Arrow down
            selected=$((selected + 1))
            if [ "$selected" -ge "$TOTAL" ]; then
                selected=0
            fi
            ;;
        "$(printf '\r')" | "$(printf '\n')")   # Enter
            handle_selection
            ;;
        q)
            clear
            printf "Exited CBHC-mod.\n"
            exit 0
            ;;
    esac
done
