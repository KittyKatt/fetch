# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 43
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light blue') # Blue
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1} 
${c1} 
${c1}                nnnnnnnnnn
${c1}           nnnnnnnnnnnnnnnnnnnn
${c1}        nnnnnnnnnnnnnnnnnnnnnnnnnn
${c1}      nnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
${c1}     nnnnnnnnnnnnnnnnnnnnnn  nnnnnnnn
${c1}    nnnnnnnnnnnnnnnnn       nnnnnnnnnn
${c1}   nnnnnnnnnnn              nnnnnnnnnnn
${c1}   nnnnnn                  nnnnnnnnnnnn
${c1}   nnnnnnnnnnn             nnnnnnnnnnnn
${c1}   nnnnnnnnnnnnn           nnnnnnnnnnnn
${c1}   nnnnnnnnnnnnnnnn       nnnnnnnnnnnnn
${c1}   nnnnnnnnnnnnnnnnn      nnnnnnnnnnnnn
${c1}   nnnnnnnnnnnnnnnnnn    nnnnnnnnnnnn
${c1}     nnnnnnnnnnnnnnnnn   nnnnnnnnnnnn
${c1}       nnnnnnnnnnnnnnn  nnnnnnnnnnn
${c1}         nnnnnnnnnnnnnn nnnnnnnnn
${c1}           nnnnnnnnnnnnnnnnnnnn
${c1}                nnnnnnnnnn
${c1}
${c1}
EOF