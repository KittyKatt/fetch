# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 36
c1=$(getColor 'white') # White
c2=$(getColor 'blue') # Blue
c3=$(getColor 'black') # Black
startline="0"
read -rd '' asciiLogo <<'EOF'
${c3}               ......
${c3}         .'${c1}D${c3}lddddddddddd'.
${c3}      .'ddd${c1}XM${c3}xdddddddddddddd.
${c3}    .dddddx${c1}MMM0${c3};dddddddddddddd.
${c3}   'dddddl${c1}MMMMMN${c3}cddddddddddddddd.
${c3}  ddddddc${c1}WMMMMMMW${c3}lddddddddddddddd.
${c3} ddddddc${c1}WMMMMMMMMO${c3}ddoddddddddddddd.
${c3}.ddddd:${c1}NMMMMMMMMMK${c3}dd${c1}NX${c3}od;c${c1}lxl${c3}dddddd
${c3}dddddc${c1}WMMMMMMMMMMNN${c3}dd${c1}MMXl${c3};d${c1}00xl;${c3}ddd.
${c3}ddddl${c1}WMMMMMMMMMMMMM${c3}d;${c1}MMMM0${c3}:dl${c1}XMMXk:${c3}'
${c3}dddo${c1}WMMMMMMMMMMMMMM${c3}dd${c1}MMMMMW${c3}od${c3};${c1}XMMMOd
${c3}.dd${c1}MMMMMMMMMMMMMMMM${c3}d:${c1}MMMMMMM${c3}kd${c1}lMKll
${c3}.;dk0${c1}KXNWWMMMMMMMMM${c3}dx${c1}MMMMMMM${c3}Xl;lxK;
${c3}  'dddddddd;:cclodcddxddolloxO0O${c1}d'
${c1}   ckkxxxddddddddxxkOOO000Okdool.
${c2}    .lddddxxxxxxddddooooooooood
${c2}      .:oooooooooooooooooooc'
${c2}         .,:looooooooooc;.
EOF