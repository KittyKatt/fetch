# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 32
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'dark grey') # Dark Grey
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}                 _a@b
${c1}              _#b (b
${c1}            _@@   @_         _,
${c1}          _#^@ _#*^^*gg,aa@^^
${c1}          #- @@^  _a@^^
${c1}          @_  *g#b
${c1}          ^@_   ^@_
${c1}            ^@_   @
${c1}             @(b (b
${c1}            #b(b#^
${c1}          _@_#@^
${c1}       _a@a*^
${c1}   ,a@*^
EOF