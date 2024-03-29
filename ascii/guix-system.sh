# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 40
# number of colors: 2
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor '202') # Orange (202/#ff5f00)
  c2=$(getColor '214') # Light Orange (214/#ffaf00)
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1} +                                    ?
${c1} ??                                  ?I
${c1}  ??I?   I??N              ${c2}???    ${c1}????
${c1}   ?III7${c2}???????          ??????${c1}7III?Z
${c1}     OI77$${c2}?????         ?????${c1}$77IIII
${c1}           ?????        ${c2}????
${c1}            ???ID      ${c2}????
${c1}             IIII     ${c2}+????
${c1}             IIIII    ${c2}????
${c1}              IIII   ${c2}?????
${c1}              IIIII  ${c2}????
${c1}               II77 ${c2}????$
${c1}               7777+${c2}????
${c1}                77++?${c2}??$
${c1}                N?+???${c2}?
EOF
