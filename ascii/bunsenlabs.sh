# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 25
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'blue') # Blue
fi
startline="5"
read -rd '' asciiLogo <<'EOF'
${c1}            HC]
${c1}          H]]]]
${c1}        H]]]]]]4
${c1}      @C]]]]]]]]*
${c1}     @]]]]]]]]]]xd
${c1}    @]]]]]]]]]]]]]d
${c1}   0]]]]]]]]]]]]]]]]
${c1}   kx]]]]]]x]]x]]]]]%%
${c1}  #x]]]]]]]]]]]]]x]]]d
${c1}  #]]]]]]qW  x]]x]]]]]4
${c1}  k]x]]xg     %%x]]]]]]%%
${c1}  Wx]]]W       x]]]]]]]
${c1}  #]]]4         xx]]x]]
${c1}   px]           ]]]]]x
${c1}   Wx]           x]]x]]
${c1}    &x           x]]]]
${c1}     m           x]]]]
${c1}                 x]x]
${c1}                 x]]]
${c1}                ]]]]
${c1}                x]x
${c1}               x]q
${c1}               ]g
${c1}              q
EOF