# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 32
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light green') # Light Green
	c2=$(getColor 'light red') # Light Red
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}    .',;:cc;,'.    .,;::c:,,.
${c1}   ,ooolcloooo:  'oooooccloo:
${c1}   .looooc;;:ol  :oc;;:ooooo'
${c1}     ;oooooo:      ,ooooooc.
${c1}       .,:;'.       .;:;'.
${c2}       .dQ. .d0Q0Q0. '0Q.
${c2}     .0Q0'   'Q0Q0Q'  'Q0Q.
${c2}     ''  .odo.    .odo.  ''
${c2}    .  .0Q0Q0Q'  .0Q0Q0Q.  .
${c2}  ,0Q .0Q0Q0Q0Q  'Q0Q0Q0b. 0Q.
${c2}  :Q0  Q0Q0Q0Q    'Q0Q0Q0  Q0'
${c2}  '0    '0Q0' .0Q0. '0'    'Q'
${c2}    .oo.     .0Q0Q0.    .oo.
${c2}    'Q0Q0.  '0Q0Q0Q0. .Q0Q0b
${c2}     'Q0Q0.  '0Q0Q0' .d0Q0Q'
${c2}      'Q0Q'    ..    '0Q.'
${c2}            .0Q0Q0Q.
${c2}             '0Q0Q'
EOF
