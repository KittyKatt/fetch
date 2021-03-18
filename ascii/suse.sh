# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 44
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light green') # Light Green
	c2=$(getColor 'white')       # White
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c2}             .;ldkO0000Okdl;.
${c2}         .;d00xl:^''''''^:ok00d;.
${c2}       .d00l'                'o00d.
${c2}     .d0K^'${c1}  Okxoc;:,.          ${c2}^O0d.
${c2}    .OVV${c1}AK0kOKKKKKKKKKKOxo:,      ${c2}lKO.
${c2}   ,0VV${c1}AKKKKKKKKKKKKK0P^${c2},,,${c1}^dx:${c2}    ;00,
${c2}  .OVV${c1}AKKKKKKKKKKKKKk'${c2}.oOPPb.${c1}'0k.${c2}   cKO.
${c2}  :KV${c1}AKKKKKKKKKKKKKK: ${c2}kKx..dd ${c1}lKd${c2}   'OK:
${c2}  lKl${c1}KKKKKKKKKOx0KKKd ${c2}^0KKKO' ${c1}kKKc${c2}   lKl
${c2}  lKl${c1}KKKKKKKKKK;.;oOKx,..${c2}^${c1}..;kKKK0.${c2}  lKl
${c2}  :KA${c1}lKKKKKKKKK0o;...^cdxxOK0O/^^'  ${c2}.0K:
${c2}   kKA${c1}VKKKKKKKKKKKK0x;,,......,;od  ${c2}lKP
${c2}   '0KA${c1}VKKKKKKKKKKKKKKKKKK00KKOo^  ${c2}c00'
${c2}    'kKA${c1}VOxddxkOO00000Okxoc;''   ${c2}.dKV'
${c2}      l0Ko.                    .c00l'
${c2}       'l0Kk:.              .;xK0l'
${c2}          'lkK0xc;:,,,,:;odO0kl'
${c2}              '^:ldxkkkkxdl:^
EOF