# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 2
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'light cyan') # Light
  c2=$(getColor 'cyan')       # Dark
fi
startline="1"
read -rd '' asciiLogo << 'EOF'
${c1}                   -`
${c1}                  .o+`
${c1}                 `ooo/
${c1}                `+oooo:
${c1}               `+oooooo:
${c1}               -+oooooo+:
${c1}             `/:-:++oooo+:
${c1}            `/++++/+++++++:
${c1}           `/++++++++++++++:
${c1}          `/+++o${c2}oooooooo${c1}oooo/`
${c2}         ${c1}./${c2}ooosssso++osssssso${c1}+`
${c2}        .oossssso-````/ossssss+`
${c2}       -osssssso.      :ssssssso.
${c2}      :osssssss/        osssso+++.
${c2}     /ossssssss/        +ssssooo/-
${c2}   `/ossssso+/:-        -:/+osssso+-
${c2}  `+sso+:-`                 `.-/+oso:
${c2} `++:.                           `-/+/
${c2} .`                                 `/
EOF
