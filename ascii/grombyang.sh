# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 35
# number of colors: 3
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'light blue')  # Light Blue
  c2=$(getColor 'light green') # Light Green
  c3=$(getColor 'light red')   # Light Red
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}
${c1}             eeeeeeeeeeee
${c1}          eeeeeeeeeeeeeeeee
${c1}       eeeeeeeeeeeeeeeeeeeeeee
${c1}     eeeee       ${c2}.o+       ${c1}eeee
${c1}   eeee         ${c2}`ooo/         ${c1}eeee
${c1}  eeee         ${c2}`+oooo:         ${c1}eeee
${c1} eee          ${c2}`+oooooo:          ${c1}eee
${c1} eee          ${c2}-+oooooo+:         ${c1}eee
${c1} ee         ${c2}`/:oooooooo+:         ${c1}ee
${c1} ee        ${c2}`/+   +++    +:        ${c1}ee
${c1} ee              ${c2}+o+             ${c1}ee
${c1} eee             ${c2}+o+            ${c1}eee
${c1} eee        ${c2}//  ooo/           ${c1}eee
${c1}  eee      ${c2}//++++oooo++++      ${c1}eee
${c1}   eeee    ${c2}::::++oooo+:::::   ${c1}eeee
${c1}     eeeee   ${c3}Grombyang OS ${c1}  eeee
${c1}       eeeeeeeeeeeeeeeeeeeeeee
${c1}          eeeeeeeeeeeeeeeee
${c1}
EOF
