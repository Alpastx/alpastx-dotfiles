#!/bin/bash

get_ip() {
    ip -4 addr show "$1" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1
}

default_iface() {
    ip -4 route show default 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i == "dev") { print $(i+1); exit }}'
}

tun_ip=$(get_ip tun0)
eth_ip=$(get_ip enp88s0)
default_iface=$(default_iface)
default_ip=""
if [[ -n "$default_iface" && "$default_iface" != "tun0" ]]; then
    default_ip=$(get_ip "$default_iface")
fi

pick_ip() {
    if [[ -n "$tun_ip" ]]; then
        echo "$tun_ip"
    elif [[ -n "$eth_ip" ]]; then
        echo "$eth_ip"
    elif [[ -n "$default_ip" ]]; then
        echo "$default_ip"
    fi
}

pick_iface() {
    if [[ -n "$tun_ip" ]]; then
        echo "tun0"
    elif [[ -n "$eth_ip" ]]; then
        echo "enp88s0"
    elif [[ -n "$default_ip" ]]; then
        echo "$default_iface"
    fi
}

pick_kind() {
    local iface="$1"
    if [[ "$iface" == "tun0" ]]; then
        echo "tun"
    elif [[ -n "$iface" ]]; then
        echo "eth"
    else
        echo "down"
    fi
}

copy_ip() {
    local ip
    ip=$(pick_ip)
    if [[ -n "$ip" ]]; then
        if command -v wl-copy &>/dev/null; then
            echo -n "$ip" | wl-copy
        elif command -v xclip &>/dev/null; then
            echo -n "$ip" | xclip -selection clipboard
        elif command -v xsel &>/dev/null; then
            echo -n "$ip" | xsel --clipboard --input
        fi
        notify-send "IP copied" "$ip"
    else
        notify-send "No IP to copy"
    fi
}

if [[ "$1" == "--copy" ]]; then
    copy_ip
    exit 0
fi

ip=$(pick_ip)
iface=$(pick_iface)
kind=$(pick_kind "$iface")

if [[ -n "$ip" ]]; then
    if [[ "$kind" == "tun" ]]; then
        tooltip="VPN tunnel (tun0)\n$ip"
    else
        tooltip="Interface: $iface\n$ip\n\nClick to copy"
    fi
    printf '{"text":"%s","class":"%s","interface":"%s","tooltip":"%s"}\n' \
        "$ip" "$kind" "$iface" "$(printf '%s' "$tooltip" | sed 's/"/\\"/g')"
else
    printf '{"text":"-","class":"down","interface":"","tooltip":"No IP address"}\n'
fi
