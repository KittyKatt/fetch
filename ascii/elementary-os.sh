# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 36
# number of colors: 1
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'white') # White
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}
${c1}         eeeeeeeeeeeeeeeee
${c1}      eeeeeeeeeeeeeeeeeeeeeee
${c1}    eeeee  eeeeeeeeeeee   eeeee
${c1}  eeee   eeeee       eee     eeee
${c1} eeee   eeee          eee     eeee
${c1}eee    eee            eee       eee
${c1}eee   eee            eee        eee
${c1}ee    eee           eeee       eeee
${c1}ee    eee         eeeee      eeeeee
${c1}ee    eee       eeeee      eeeee ee
${c1}eee   eeee   eeeeee      eeeee  eee
${c1}eee    eeeeeeeeee     eeeeee    eee
${c1} eeeeeeeeeeeeeeeeeeeeeeee    eeeee
${c1}  eeeeeeee eeeeeeeeeeee      eeee
${c1}    eeeee                 eeeee
${c1}      eeeeeee         eeeeeee
${c1}         eeeeeeeeeeeeeeeee
EOF
