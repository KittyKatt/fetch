# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 37
c1=$(getColor 'grey') # Gray
c2=$(getColor 'purple') # Dark Purple
c3=$(getColor 'light purple') # Light Purple
startline="0"
read -rd '' asciiLogo <<'EOF'
${c2}               .,,,,.
${c2}         .,'onNMMMMMNNnn',.
${c2}      .'oNM${c3}ANK${c2}MMMMMMMMMMMNNn'.
${c3}    .'ANMMMMMMMXK${c2}NNWWWPFFWNNMNn.
${c3}   ;NNMMMMMMMMMMNWW'' ${c2},.., 'WMMM,
${c3}  ;NMMMMV+##+VNWWW' ${c3}.+;'':+, 'WM${c2}W,
${c3} ,VNNWP+${c1}######${c3}+WW,  ${c1}+:    ${c3}:+, +MMM,
${c3} '${c1}+#############,   +.    ,+' ${c3}+NMMM
${c1}   '*#########*'     '*,,*' ${c3}.+NMMMM.
${c1}      `'*###*'          ,.,;###${c3}+WNM,
${c1}          .,;;,      .;##########${c3}+W
${c1} ,',.         ';  ,+##############'
${c1}  '###+. :,. .,; ,###############'
${c1}   '####.. `'' .,###############'
${c1}     '#####+++################'
${c1}       '*##################*'
${c1}          ''*##########*''
${c1}               ''''''
EOF