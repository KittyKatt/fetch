# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'white') # White
c2=$(getColor 'light blue') # Blue
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c2}            ...........
${c2}         ..             ..
${c2}      ..                   ..
${c2}    ..           ${c1}o           ${c2}..
${c2}  ..            ${c1}:W'            ${c2}..
${c2} ..             ${c1}.d.             ${c2}..
${c2}:.             ${c1}.KNO              ${c2}.:
${c2}:.             ${c1}cNNN.             ${c2}.:
${c2}:              ${c1}dXXX,              ${c2}:
${c2}:   ${c1}.          dXXX,       .cd,   ${c2}:
${c2}:   ${c1}'kc ..     dKKK.    ,ll;:'    ${c2}:
${c2}:     ${c1}.xkkxc;..dkkkc',cxkkl       ${c2}:
${c2}:.     ${c1}.,cdddddddddddddo:.       ${c2}.:
${c2} ..         ${c1}:lllllll:           ${c2}..
${c2}   ..         ${c1}',,,,,          ${c2}..
${c2}     ..                     ..
${c2}        ..               ..
${c2}          ...............
EOF
