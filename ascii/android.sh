# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 24
# number of colors: 1
c1=$(getColor 'light green') # Bold Green
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