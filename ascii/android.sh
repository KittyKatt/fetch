# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 24
# number of colors: 1
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'light green') # Bold Green
fi
startline="2"
read -rd '' asciiLogo <<'EOF'
${c1}       ╲ ▁▂▂▂▁ ╱
${c1}       ▄███████▄
${c1}      ▄██ ███ ██▄
${c1}     ▄███████████▄
${c1}  ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄ █▄
${c1}  ██ █████████████ ██
${c1}  ██ █████████████ ██
${c1}  ██ █████████████ ██
${c1}  ██ █████████████ ██
${c1}     █████████████
${c1}      ███████████
${c1}       ██     ██
${c1}       ██     ██
EOF
