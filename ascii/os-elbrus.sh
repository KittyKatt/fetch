# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 33
# number of colors: 1
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'light blue') # Light Blue
fi
startline="1"
read -rd '' asciiLogo << 'EOF'
${c1}
${c1}   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
${c1}   ██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██
${c1}   ██                       ██
${c1}   ██   ███████   ███████   ██
${c1}   ██   ██   ██   ██   ██   ██
${c1}   ██   ██   ██   ██   ██   ██
${c1}   ██   ██   ██   ██   ██   ██
${c1}   ██   ██   ██   ██   ██   ██
${c1}   ██   ██   ███████   ███████
${c1}   ██   ██                  ██
${c1}   ██   ██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄██
${c1}   ██   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀██
${c1}   ██                       ██
${c1}   ███████████████████████████
${c1}
EOF
