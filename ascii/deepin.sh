# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 41
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
  c1=$(getColor 'light cyan') # Light Cyan
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}              ............
${c1}          .';;;;;.       .,;,.
${c1}       .,;;;;;;;.       ';;;;;;;.
${c1}     .;::::::::'     .,::;;,''''',.
${c1}    ,'.::::::::    .;;'.          ';
${c1}   ;'  'cccccc,   ,' :: '..        .:
${c1}  ,,    :ccccc.  ;: .c, '' :.       ,;
${c1} .l.     cllll' ., .lc  :; .l'       l.
${c1} .c       :lllc  ;cl:  .l' .ll.      :'
${c1} .l        'looc. .   ,o:  'oo'      c,
${c1} .o.         .:ool::coc'  .ooo'      o.
${c1}  ::            .....   .;dddo      ;c
${c1}   l:...            .';lddddo.     ,o
${c1}    lxxxxxdoolllodxxxxxxxxxc      :l
${c1}     ,dxxxxxxxxxxxxxxxxxxl.     'o,
${c1}       ,dkkkkkkkkkkkkko;.    .;o;
${c1}         .;okkkkkdl;.    .,cl:.
${c1}             .,:cccccccc:,.
EOF
