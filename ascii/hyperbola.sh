# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 25
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'light grey') # light grey
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}                  ..              ,
${c1}                  a;           ._#
${c1}                 )##        _au#?
${c1}                 ]##s,.__a_w##e^
${c1}                 :###########(
${c1}                  ^!#####?!^
${c1}                  ._
${c1}             _au######a,
${c1}           sa###########,
${c1}        _a##############o
${c1}      .a#####?!^^^^^-####_
${c1}     j####^           ~##i
${c1}   _de!^               -#i
${c1} _#e^                   ]+
${c1} ^                      ^
${c1}
EOF
