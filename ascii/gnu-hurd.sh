# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 37
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'dark grey') # Light Gray
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}    _-`````-,           ,- '- .
${c1}   .'   .- - |          | - -.  `.
${c1}  /.'  /                     `.   
${c1} :/   :      _...   ..._      ``   :
${c1} ::   :     /._ .`:'_.._.    ||   :
${c1} ::    `._ ./  ,`  :     . _.''   .
${c1} `:.      /   |  -.  -. _      /
${c1}   :._ _/  .'   .@)  @) ` ` ,.'
${c1}      _/,--'       .- .,-.`--`.
${c1}        ,'/''     ((  `  )
${c1}         /'/'      `-'  (
${c1}          '/''  `._,-----'
${c1}           ''/'    .,---'
${c1}            ''/'      ;:
${c1}              ''/''  ''/
${c1}                ''/''/''
${c1}                  '/'/'
${c1}                   `;
EOF
