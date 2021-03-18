# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 44
# number of colors: 5
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'yellow')     # Yellow
	c2=$(getColor 'brown')      # Brown
	c3=$(getColor 'light cyan') # Light Cyan
	c4=$(getColor 'light red')  # Light Red
	c5=$(getColor 'dark grey')  # Dark Grey
fi
startline="3"
read -rd '' asciiLogo <<'EOF'
${c3}
${c3}                                       (_)
${c1}
${c1}          .   |L  /|   .         ${c3} _
${c1}      _ . | _| --+._/| .       ${c3}(_)
${c1}     / ||| Y J  )   / |/| ./
${c1}    J  |)'( |        ` F`.'/       ${c3} _
${c1}  -<|  F         __     .-<        ${c3}(_)
${c1}    | /       .-'${c3}. ${c1}`.  /${c3}-. ${c1}L___
${c1}    J       <    ${c3} ${c1} | | ${c5}O${c3}${c1}|.-' ${c3} _
${c1}  _J   .-    ${c3}/ ${c5}O ${c3}| ${c1}|   |${c1}F    ${c3}(_)
${c1} '-F  -<_.        .-'  `-' L__
${c1}__J  _   _.     >-'  ${c2})${c4}._.   ${c1}|-'
${c1} `-|.'   /_.          ${c4}_|  ${c1} F
${c1}  /.-   .                _.<
${c1} /'    /.'             .'  `
${c1}  /L  /'   |/      _.-'-
${c1} /'J       ___.---'|
${c1}   |  .--' V  | `. `
${c1}   |/`. `-.     `._)
${c1}      / .-.
${c1}       (  `
${c1}       `.
EOF