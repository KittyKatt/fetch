# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 48
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
    c1=$(getColor 'light blue') # Light Blue
    c2=$(getColor 'black')      # Black
fi
startline="1"
read -rd '' asciiLogo << 'EOF'
${c1}..............
${c1}            ..,;:ccc,.
${c1}          ......''';lxO.
${c1}.....''''..........,:ld;
${c1}           .';;;:::;,,.x,
${c1}      ..'''.            0Xxoc:,.  ...
${c1}  ....                ,ONkc;,;cokOdc',.
${c1} .                   OMo           ':${c2}dd${c1}o.
${c1}                    dMc               :OO;
${c1}                    0M.                 .:o.
${c1}                    ;Wd
${c1}                     ;XO,
${c1}                       ,d0Odlc;,..
${c1}                           ..',;:cdOOd::,.
${c1}                                    .:d;.':;.
${c1}                                       'd,  .'
${c1}                                         ;l   ..
${c1}                                          .o
${c1}                                            c
${c1}                                            .'
${c1}                                             .
EOF
