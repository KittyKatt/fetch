# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 36
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light purple') # Light purple
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}     ..,,;;;::;,..
${c1}             `':ddd;:,.
${c1}                   `'dPPd:,.
${c1}                       `:b$$b`.
${c1}                          'P$$$d`
${c1}                           .$$$$$`
${c1}                           ;$$$$$P
${c1}                        .:P$$$$$$`
${c1}                    .,:b$$$$$$$;'
${c1}               .,:dP$$$$$$$$b:'
${c1}        .,:;db$$$$$$$$$$Pd'`
${c1}   ,db$$$$$$$$$$$$$$b:'`
${c1}  :$$$$$$$$$$$$b:'`
${c1}   `$$$$$bd:''`
${c1}     `'''`
${c1}
EOF
