# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 47
# number of colors: 3
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'cyan')       # Cyan
	c2=$(getColor 'blue')       # Blue
	c3=$(getColor 'light blue') # Light Blue
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c3}                      ####
${c3}                    ########
${c3}                  ############
${c3}                #######  #######
${c1}              #${c3}######      ######${c2}#
${c1}            ####${c3}###          ###${c2}####
${c1}          ######        ${c2}        ######
${c1}          ######        ${c2}        ######
${c1}          ######        ${c2}        ######
${c1}          ######        ${c2}        ######
${c1}          ######        ${c2}        ######
${c1}            #######     ${c2}     #######
${c1}              #######   ${c2}   #########
${c1}                ####### ${c2} ##############
${c1}                  ######${c2}######  ######
${c1}                    ####${c2}####     ###
${c1}                      ##${c2}##
${c1}
EOF