# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 37
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light grey') # Light Grey
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