# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 43
if [ "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light blue') # Blue
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1} nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
${c1} nnnnnnnnnnnnnn            nnnnnnnnnnnnnn
${c1} nnnnnnnnnn     nnnnnnnnnn     nnnnnnnnnn
${c1} nnnnnnn   nnnnnnnnnnnnnnnnnnnn   nnnnnnn
${c1} nnnn   nnnnnnnnnnnnnnnnnnnnnnnnnn   nnnn
${c1} nnn  nnnnnnnnnnnnnnnnnnnnnnnnnnnnnn  nnn
${c1} nn  nnnnnnnnnnnnnnnnnnnnnn  nnnnnnnn  nn
${c1} n  nnnnnnnnnnnnnnnnn       nnnnnnnnnn  n
${c1} n nnnnnnnnnnn              nnnnnnnnnnn n
${c1} n nnnnnn                  nnnnnnnnnnnn n
${c1} n nnnnnnnnnnn             nnnnnnnnnnnn n
${c1} n nnnnnnnnnnnnn           nnnnnnnnnnnn n
${c1} n nnnnnnnnnnnnnnnn       nnnnnnnnnnnnn n
${c1} n nnnnnnnnnnnnnnnnn      nnnnnnnnnnnnn n
${c1} n nnnnnnnnnnnnnnnnnn    nnnnnnnnnnnn   n
${c1} nn  nnnnnnnnnnnnnnnnn   nnnnnnnnnnnn  nn
${c1} nnn   nnnnnnnnnnnnnnn  nnnnnnnnnnn   nnn
${c1} nnnnn   nnnnnnnnnnnnnn nnnnnnnnn   nnnnn
${c1} nnnnnnn   nnnnnnnnnnnnnnnnnnnn   nnnnnnn
${c1} nnnnnnnnnn     nnnnnnnnnn     nnnnnnnnnn
${c1} nnnnnnnnnnnnnn            nnnnnnnnnnnnnn
${c1} nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
${c1}
EOF
