# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 4
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'cyan')      # Cyan
  c2=$(getColor 'blue')      # Blue
  c3=$(getColor 'green')     # Green
  c4=$(getColor 'dark grey') # Dark Grey
fi
startline="1"
read -rd '' asciiLogo << 'EOF'
${c1}                        d${c2}c.
${c1}                       x${c2}dc.
${c1}                  '.${c4}.${c1} d${c2}dlc.
${c1}                 c${c2}0d:${c1}o${c2}xllc;
${c1}                :${c2}0ddlolc,lc,
${c1}           :${c1}ko${c4}.${c1}:${c2}0ddollc..dlc.
${c1}          ;${c1}K${c2}kxoOddollc'  cllc.
${c1}         ,${c1}K${c2}kkkxdddllc,   ${c4}.${c2}lll:
${c1}        ,${c1}X${c2}kkkddddlll;${c3}...';${c1}d${c2}llll${c3}dxk:
${c1}       ,${c1}X${c2}kkkddddllll${c3}oxxxddo${c2}lll${c3}oooo,
${c3}    xxk${c1}0${c2}kkkdddd${c1}o${c2}lll${c1}o${c3}ooooooolooooc;${c1}.
${c3}    ddd${c2}kkk${c1}d${c2}ddd${c1}ol${c2}lc:${c3}:;,'.${c3}... .${c2}lll;
${c1}   .${c3}xd${c1}x${c2}kk${c1}xd${c2}dl${c1}'cl:${c4}.           ${c2}.llc,
${c1}   .${c1}0${c2}kkkxddl${c4}. ${c2};'${c4}.             ${c2};llc.
${c1}  .${c1}K${c2}Okdcddl${c4}.                   ${c2}cllc${c4}.
${c1}  0${c2}Okd''dc.                    .cll;
${c1} k${c2}Okd'                          .llc,
${c1} d${c2}Od,                            'lc.
${c1} :,${c4}.                              ${c2}...
${c1}
EOF
