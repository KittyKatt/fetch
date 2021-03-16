# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 50
c1=$(getColor 'white') # White
c2=$(getColor 'light blue') # Light Blue
startline="3"
read -rd '' asciiLogo <<'EOF'
${c2}          `++/::-.`
${c2}         /o+++++++++/::-.`
${c2}        `o+++++++++++++++o++/::-.`
${c2}        /+++++++++++++++++++++++oo++/:-.``
${c2}       .o+ooooooooooooooooooosssssssso++oo++/:-`
${c2}       ++osoooooooooooosssssssssssssyyo+++++++o:
${c2}      -o+ssoooooooooooosssssssssssssyyo+++++++s`
${c2}      o++ssoooooo++++++++++++++sssyyyyo++++++o:
${c2}     :o++ssoooooo${c1}/-------------${c2}+syyyyyo+++++oo
${c2}    `o+++ssoooooo${c1}/-----${c2}+++++ooosyyyyyyo++++os:
${c2}    /o+++ssoooooo${c1}/-----${c2}ooooooosyyyyyyyo+oooss
${c2}   .o++++ssooooos${c1}/------------${c2}syyyyyyhsosssy-
${c2}   ++++++ssooooss${c1}/-----${c2}+++++ooyyhhhhhdssssso
${c2}  -s+++++syssssss${c1}/-----${c2}yyhhhhhhhhhhhddssssy.
${c2}  sooooooyhyyyyyh${c1}/-----${c2}hhhhhhhhhhhddddyssy+
${c2} :yooooooyhyyyhhhyyyyyyhhhhhhhhhhdddddyssy`
${c2} yoooooooyhyyhhhhhhhhhhhhhhhhhhhddddddysy/
${c2}-ysooooooydhhhhhhhhhhhddddddddddddddddssy
${c2} .-:/+osssyyyysyyyyyyyyyyyyyyyyyyyyyyssy:
${c2}       ``.-/+oosysssssssssssssssssssssss
${c2}               ``.:/+osyysssssssssssssh.
${c2}                        `-:/+osyyssssyo
${c2}                                .-:+++`
EOF