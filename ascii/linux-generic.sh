# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 28
# number of colors: 3
if [ ! "${config_text[color]}" == "off" ]; then
  c1=$(getColor 'white')     # White
  c2=$(getColor 'dark grey') # Dark Grey
  c3=$(getColor 'yellow')    # Yellow
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c2}
${c2}
${c2}
${c2}         #####
${c2}        #######
${c2}        ##${c1}O${c2}#${c1}O${c2}##
${c2}        #${c3}#####${c2}#
${c2}      ##${c1}##${c3}###${c1}##${c2}##
${c2}     #${c1}##########${c2}##
${c2}    #${c1}############${c2}##
${c2}    #${c1}############${c2}###
${c3}   ##${c2}#${c1}###########${c2}##${c3}#
${c3} ######${c2}#${c1}#######${c2}#${c3}######
${c3} #######${c2}#${c1}#####${c2}#${c3}#######
${c3}   #####${c2}#######${c3}#####
${c2}
${c2}
${c2}
EOF
