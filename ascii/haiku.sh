# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 36			
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'black_haiku') # Black
c2=$(getColor 'light grey') # Light Gray
c3=$(getColor 'green') # Green
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}          :dc'
${c1}       'l:;'${c2},${c1}'ck.    .;dc:.
${c1}       co    ${c2}..${c1}k.  .;;   ':o.
${c1}       co    ${c2}..${c1}k. ol      ${c2}.${c1}0.
${c1}       co    ${c2}..${c1}k. oc     ${c2}..${c1}0.
${c1}       co    ${c2}..${c1}k. oc     ${c2}..${c1}0.
${c1}.Ol,.  co ${c2}...''${c1}Oc;kkodxOdddOoc,.
${c1} ';lxxlxOdxkxk0kd${c3}oooll${c1}dl${c3}ccc:${c1}clxd;
${c1}     ..${c3}oOolllllccccccc:::::${c1}od;
${c1}       cx:ooc${c3}:::::::;${c1}cooolcX.
${c1}       cd${c2}.${c1}''cloxdoollc' ${c2}...${c1}0.
${c1}       cd${c2}......${c1}k;${c2}.${c1}xl${c2}....  .${c1}0.
${c1}       .::c${c2};..${c1}cx;${c2}.${c1}xo${c2}..... .${c1}0.
${c1}          '::c'${c2}...${c1}do${c2}..... .${c1}K,
${c1}                  cd,.${c2}....:${c1}O,${c2}......
${c1}                    ':clod:'${c2}......
${c1}                        ${c2}.
EOF
