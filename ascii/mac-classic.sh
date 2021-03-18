# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 39
# number of colors: 4
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'blue')       # Blue
	c2=$(getColor 'light blue') # Light blue
	c3=$(getColor 'light grey') # Light Gray
	c4=$(getColor 'dark grey')  # Dark Grey
fi
startline=1
read -rd '' asciiLogo <<'EOF'
${c3}
${c3}                        ..
${c3}                       dWc
${c3}                     ,X0'
${c1}  ;;;;;;;;;;;;;;;;;;${c3}0Mk${c2}:::::::::::::::
${c1}  ;;;;;;;;;;;;;;;;;${c3}KWo${c2}::::::::::::::::
${c1}  ;;;;;;;;;${c4}NN${c1};;;;;${c3}KWo${c2}:::::${c3}NN${c2}::::::::::
${c1}  ;;;;;;;;;${c4}NN${c1};;;;${c3}0Md${c2}::::::${c3}NN${c2}::::::::::
${c1}  ;;;;;;;;;${c4}NN${c1};;;${c3}xW0${c2}:::::::${c3}NN${c2}::::::::::
${c1}  ;;;;;;;;;;;;;;${c3}KMc${c2}:::::::::::::::::::
${c1}  ;;;;;;;;;;;;;${c3}lWX${c2}::::::::::::::::::::
${c1}  ;;;;;;;;;;;;;${c3}xWWXXXXNN7${c2}:::::::::::::
${c1}  ;;;;;;;;;;;;;;;;;;;;${c3}WK${c2}::::::::::::::
${c1}  ;;;;;${c4}TKX0ko.${c1};;;;;;;${c3}kMx${c2}:::${c3}.cOKNF${c2}:::::
${c1}  ;;;;;;;;${c4}`kO0KKKKKKK${c3}NMNXK0OP*${c2}::::::::
${c1}  ;;;;;;;;;;;;;;;;;;;${c3}kMx${c2}::::::::::::::
${c1}  ;;;;;;;;;;;;;;;;;;;;${c3}WX${c2}::::::::::::::
${c3}                      lMc
${c3}                       kN.
${c3}                        o'
${c3}
EOF