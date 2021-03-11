# logo width: 33
c1=$(getColor 'green') # Green
c2=$(getColor 'yellow') # Yellow
startline="0"
read -rd '' asciiLogo <<'EOF'
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