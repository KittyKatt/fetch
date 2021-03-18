# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 4
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'yellow')    # Yellow
	c2=$(getColor 'white')     # White
	c3=$(getColor 'light red') # Light Red
	c4=$(getColor 'dark grey') # Dark Grey
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c4}                oxoo
${c4}           ooooooxxxxxxxx
${c4}      oooooxxxxxxxxxx${c3}O${c1}o.${c4}xx
${c4}    oo# ###xxxxxxxxxxx###xxx
${c4}  oo .oooooxxxxxxxxx##   #oxx
${c4} o  ##xxxxxxxxx###x##   .o###
${c4}  .oxxxxxxxx###   ox  .
${c4} ooxxxx#xxxxxx     o##
${c4}.oxx# #oxxxxx#
${c4}ox#  ooxxxxxx#                  o
${c4}x#  ooxxxxxxxx           ox     ox
${c4}x# .oxxxxxxxxxxx        o#     oox
${c4}#  oxxxxx##xxxxxxooooooo#      o#
${c4}  .oxxxxxooxxxxxx######       ox#
${c4}  oxxxxxo oxxxxxxxx         oox##
${c4}  oxxxxxx  oxxxxxxxxxo   oooox##
${c4}   o#xxxxx  oxxxxxxxxxxxxxxxx##
${c4}    ##xxxxx  o#xxxxxxxxxxxxx##
${c4}      ##xxxx   o#xxxxxxxxx##
${c4}         ###xo.  o##xxx###
${c4}
EOF