# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light blue') # Light Blue
	c2=$(getColor 'light cyan') # Light Cyan
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}                          ▄▄▄▄▄▄
${c1}                       ▄█████████▄
${c1}       ▄▄▄▄▄▄         ████▀   ▀████
${c1}    ▄██████████▄     ████▀   ▄▄ ▀███
${c1}  ▄███▀▀   ▀▀████     ███▄   ▄█   ███
${c1} ▄███   ▄▄▄   ████▄    ▀██████   ▄███
${c1} ███   █▀▀██▄  █████▄     ▀▀   ▄████
${c1} ▀███      ███  ███████▄▄  ▄▄██████
${c1}  ▀███▄   ▄███  █████████████${c2}████▀
${c1}   ▀█████████    ███████${c2}███▀▀▀
${c1}     ▀▀███▀▀     ██${c2}████▀▀
${c2}                ██████▀   ▄▄▄▄
${c2}               █████▀   ████████
${c2}               █████   ███▀  ▀███
${c2}                ████▄   ██▄▄▄  ███
${c2}                 █████▄   ▀▀  ▄██
${c2}                   ██████▄▄▄████
${c2}		              █████▀▀
EOF