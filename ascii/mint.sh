# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
    c1=$(getColor 'white')       # White
    c2=$(getColor 'light green') # Bold Green
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c2}
${c2} MMMMMMMMMMMMMMMMMMMMMMMMMmds+.
${c2} MMm----::-://////////////oymNMd+`
${c2} MMd      ${c1}/++                ${c2}-sNMd:
${c2} MMNso/`  ${c1}dMM    `.::-. .-::.` ${c2}.hMN:
${c2} ddddMMh  ${c1}dMM   :hNMNMNhNMNMNh: ${c2}`NMm
${c2}     NMm  ${c1}dMM  .NMN/-+MMM+-/NMN` ${c2}dMM
${c2}     NMm  ${c1}dMM  -MMm  `MMM   dMM. ${c2}dMM
${c2}     NMm  ${c1}dMM  -MMm  `MMM   dMM. ${c2}dMM
${c2}     NMm  ${c1}dMM  .mmd  `mmm   yMM. ${c2}dMM
${c2}     NMm  ${c1}dMM`  ..`   ...   ydm. ${c2}dMM
${c2}     hMM- ${c1}+MMd/-------...-:sdds  ${c2}dMM
${c2}     -NMm- ${c1}:hNMNNNmdddddddddy/`  ${c2}dMM
${c2}      -dMNs-${c1}``-::::-------.``    ${c2}dMM
${c2}       `/dMNmy+/:-------------:/yMMM
${c2}          ./ydNMMMMMMMMMMMMMMMMMMMMM
${c2}             .MMMMMMMMMMMMMMMMMMM
${c2}
EOF
