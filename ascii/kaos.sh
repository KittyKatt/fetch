# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 35
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light blue') # Light Blue
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}                     ..
${c1}  .....         ..OSSAAAAAAA..
${c1} .KKKKSS.     .SSAAAAAAAAAAA.
${c1}.KKKKKSO.    .SAAAAAAAAAA...
${c1}KKKKKKS.   .OAAAAAAAA.
${c1}KKKKKKS.  .OAAAAAA.
${c1}KKKKKKS. .SSAA..
${c1}.KKKKKS..OAAAAAAAAAAAA........
${c1} DKKKKO.=AA=========A===AASSSO..
${c1}  AKKKS.==========AASSSSAAAAAASS.
${c1}  .=KKO..========ASS.....SSSSASSSS.
${c1}    .KK.       .ASS..O.. =SSSSAOSS:
${c1}     .OK.      .ASSSSSSSO...=A.SSA.
${c1}       .K      ..SSSASSSS.. ..SSA.
${c1}                 .SSS.AAKAKSSKA.
${c1}                    .SSS....S..
EOF