# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 35
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
  c1=$(getColor 'light blue') # Light Blue
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}               _ass,,
${c1}              jmk  dm.
${c1}              3##qwm#`
${c1}          .    "9XZ?` _aas,
${c1}        ap!!n,      _dW(--$a
${c1}       )#hc_m#      ]mmwaam#`
${c1}        ?##WZ^      -4#####! _as,.
${c1}  _ais,   -   _au11a. -""" <m#"""Wc
${c1} )m6_]m,      m#c__m6     :m#m,_<m#>
${c1} -Y#m#!       4###m#r     -$##mBm#Z`
${c1}    -    _as,. "???~ _aawa,.!S##Z?`
${c1}        ym= 3h.     <##' -Wo
${c1}        $#mm#D`     ]B#qww##
${c1}         "?!"`  _s,.-?#m##T'
${c1}              _dZ""4a  --
${c1}              3Wmaam#;
${c1}              -9###Z!
EOF
