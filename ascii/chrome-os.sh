# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 5
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'green') # Green
c2=$(getColor 'light red') # Light Red
c3=$(getColor 'yellow') # Bold Yellow
c4=$(getColor 'light blue') # Light Blue
c5=$(getColor 'white') # White
fi
startline="0"
read -rd '' asciiLogo <<'EOF'            
${c2}             .,:loool:,.
${c2}         .,coooooooooooooc,.
${c2}      .,lllllllllllllllllllll,.
${c2}     ;ccccccccccccccccccccccccc;
${c1}   '${c2}ccccccccccccccccccccccccccccc.
${c1}  ,oo${c2}c::::::::okO${c5}000${c3}0OOkkkkkkkkkkk:
${c1} .ooool${c2};;;;:x${c5}K0${c4}kxxxxxk${c5}0X${c3}K0000000000.
${c1} :oooool${c2};,;O${c5}K${c4}ddddddddddd${c5}KX${c3}000000000d
${c1} lllllool${c2};l${c5}N${c4}dllllllllllld${c5}N${c3}K000000000
${c1} lllllllll${c2}o${c5}M${c4}dccccccccccco${c5}W${c3}K000000000
${c1} ;cllllllllX${c5}X${c4}c:::::::::c${c5}0X${c3}000000000d
${c1} .ccccllllllO${c5}Nk${c4}c;,,,;cx${c5}KK${c3}0000000000.
${c1}  .cccccclllllxOO${c5}OOO${c1}Okx${c3}O0000000000;
${c1}   .:ccccccccllllllllo${c3}O0000000OOO,
${c1}     ,:ccccccccclllcd${c3}0000OOOOOOl.
${c1}       '::ccccccccc${c3}dOOOOOOOkx:.
${c1}         ..,::cccc${c3}xOOOkkko;.
${c1}             ..,:${c3}dOkxl:.
EOF
