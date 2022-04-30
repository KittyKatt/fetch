# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 33
# number of colors: 2
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'green')  # Green
  c2=$(getColor 'yellow') # Yellow
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}                         ###
${c1}     ###             ####
${c1}        ###       ####
${c1}         ##### #####
${c1}      #################
${c1}    ###     #####    ####
${c1}   ##        ${c2}OOO       ${c1}###
${c1}  #          ${c2}WW         ${c1}##
${c1}            ${c2}WW            ${c1}#
${c2}            WW
${c2}            WW
${c2}           WW
${c2}           WW
${c2}           WW
${c2}          WW
${c2}          WW
${c2}          WW
${c2}
EOF
