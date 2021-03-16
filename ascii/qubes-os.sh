# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 47
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'cyan')
	c2=$(getColor 'blue')
	c3=$(getColor 'light blue')
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
