# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 40
# number of colors: 4
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'yellow')
c2=$(getColor 'light green')
c3=$(getColor 'light blue')
c4=$(getColor 'light purple')
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}                   ..
${c1}                 .PLTJ.
${c1}                <><><><>
${c2}       KKSSV' 4KKK ${c1}LJ${c4} KKKL.'VSSKK
${c2}       KKV' 4KKKKK ${c1}LJ${c4} KKKKAL 'VKK
${c2}       V' ' 'VKKKK ${c1}LJ${c4} KKKKV' ' 'V
${c2}       .4MA.' 'VKK ${c1}LJ${c4} KKV' '.4Mb.
${c4}     . ${c2}KKKKKA.' 'V ${c1}LJ${c4} V' '.4KKKKK ${c3}.
${c4}   .4D ${c2}KKKKKKKA.'' ${c1}LJ${c4} ''.4KKKKKKK ${c3}FA.
${c4}  <QDD ++++++++++++  ${c3}++++++++++++ GFD>
${c4}   'VD ${c3}KKKKKKKK'.. ${c2}LJ ${c1}..'KKKKKKKK ${c3}FV
${c4}     ' ${c3}VKKKKK'. .4 ${c2}LJ ${c1}K. .'KKKKKV ${c3}'
${c3}        'VK'. .4KK ${c2}LJ ${c1}KKA. .'KV'
${c3}       A. . .4KKKK ${c2}LJ ${c1}KKKKA. . .4
${c3}       KKA. 'KKKKK ${c2}LJ ${c1}KKKKK' .4KK
${c3}       KKSSA. VKKK ${c2}LJ ${c1}KKKV .4SSKK
${c2}                <><><><>
${c2}                 'MKKM'
${c2}                   ''
EOF
