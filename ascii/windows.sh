# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light blue') # Blue
fi
startline=1
read -rd '' asciiLogo <<'EOF'
${c1}                                  ..,
${c1}                      ....,,:;+ccllll
${c1}        ...,,+:;  cllllllllllllllllll
${c1}  ,cclllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}                                     
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  llllllllllllll  lllllllllllllllllll
${c1}  `'ccllllllllll  lllllllllllllllllll
${c1}         `'""*::  :ccllllllllllllllll
${c1}                        ````''"*::cll
${c1}                                   ``
EOF
