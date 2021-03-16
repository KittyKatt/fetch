# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 43
# number of colors: 4
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light red') # Red
	c2=$(getColor 'white') # White
	c3=$(getColor 'yellow')
	c4=$(getColor 'light red')
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}                      |
${c1}                     .-.
${c3}                    ()${c1}I${c3}()
${c1}               "==.__:-:__.=="
${c1}              "==.__/~|~__.=="
${c1}              "==._(  Y  )_.=="
${c2}   .-'~~""~=--...,__${c1}/|/${c2}__,...--=~""~~'-.
${c2}  (               ..=${c1}=${c1}/${c2}=..               )
${c2}   `'-.        ,.-"`;${c1}/=${c2} ;"-.,_        .-'`
${c2}       `~"-=-~` .-~` ${c1}|=|${c2} `~-. `~-=-"~`
${c2}            .-~`    /${c1}|=|${c2}    `~-.
${c2}         .~`       / ${c1}|=|${c2}        `~.
${c2}     .-~`        .'  ${c1}|=|${c2}  `.        `~-.
${c2}   (`     _,.-="`    ${c1}|=|${c2}    `"=-.,_     `)
${c2}    `~"~"`           ${c1}|=|${c2}           `"~"~`
${c1}                     /=
${c1}                     =/
${c1}                      ^
EOF
