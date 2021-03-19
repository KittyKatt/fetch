# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 37
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
    c1=$(getColor 'white')        # White
    c2=$(getColor 'light purple') # Light Purple
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c2}         -/oyddmdhs+:.
${c2}     -o${c1}dNMMMMMMMMNNmhy+${c2}-`
${c2}   -y${c1}NMMMMMMMMMMMNNNmmdhy${c2}+-
${c2} `o${c1}mMMMMMMMMMMMMNmdmmmmddhhy${c2}/`
${c2} om${c1}MMMMMMMMMMMN${c2}hhyyyo${c1}hmdddhhhd${c2}o`
${c2}.y${c1}dMMMMMMMMMMd${c2}hs++so/s${c1}mdddhhhhdm${c2}+`
${c2} oy${c1}hdmNMMMMMMMN${c2}dyooy${c1}dmddddhhhhyhN${c2}d.
${c2}  :o${c1}yhhdNNMMMMMMMNNNmmdddhhhhhyym${c2}Mh
${c2}    .:${c1}+sydNMMMMMNNNmmmdddhhhhhhmM${c2}my
${c2}       /m${c1}MMMMMMNNNmmmdddhhhhhmMNh${c2}s:
${c2}    `o${c1}NMMMMMMMNNNmmmddddhhdmMNhs${c2}+`
${c2}  `s${c1}NMMMMMMMMNNNmmmdddddmNMmhs${c2}/.
${c2} /N${c1}MMMMMMMMNNNNmmmdddmNMNdso${c2}:`
${c2}+M${c1}MMMMMMNNNNNmmmmdmNMNdso${c2}/-
${c2}yM${c1}MNNNNNNNmmmmmNNMmhs+/${c2}-`
${c2}/h${c1}MMNNNNNNNNMNdhs++/${c2}-`
${c2}`/${c1}ohdmmddhys+++/:${c2}.`
${c2}  `-//////:--.
EOF
