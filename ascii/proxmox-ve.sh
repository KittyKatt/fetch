# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 48
if [ "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'white')
	c2=$(getColor 'orange')
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}           .://:`              `://:.
${c1}         `hMMMMMMd/          /dMMMMMMh`
${c1}          `sMMMMMMMd:      :mMMMMMMMs`
${c2}  `-/+oo+/:${c1}`.yMMMMMMMh-  -hMMMMMMMy.`${c2}:/+oo+/-`
${c2}  `:oooooooo/${c1}`-hMMMMMMMyyMMMMMMMh-`${c2}/oooooooo:`
${c2}    `/oooooooo:${c1}`:mMMMMMMMMMMMMm:`${c2}:oooooooo/`
${c2}      ./ooooooo+-${c1} +NMMMMMMMMN+ ${c2}-+ooooooo/.
${c2}        .+ooooooo+-${c1}`oNMMMMNo`${c2}-+ooooooo+.
${c2}          -+ooooooo/.${c1}`sMMs`${c2}./ooooooo+-
${c2}            :oooooooo/${c1}`..`${c2}/oooooooo:
${c2}            :oooooooo/`${c1}..${c2}`/oooooooo:
${c2}          -+ooooooo/.${c1}`sMMs${c2}`./ooooooo+-
${c2}        .+ooooooo+-`${c1}oNMMMMNo${c2}`-+ooooooo+.
${c2}      ./ooooooo+-${c1} +NMMMMMMMMN+ ${c2}-+ooooooo/.
${c2}    `/oooooooo:`${c1}:mMMMMMMMMMMMMm:${c2}`:oooooooo/`
${c2}  `:oooooooo/`${c1}-hMMMMMMMyyMMMMMMMh-${c2}`/oooooooo:`
${c2}  `-/+oo+/:`${c1}.yMMMMMMMh-  -hMMMMMMMy.${c2}`:/+oo+/-`
${c1}          `sMMMMMMMm:      :dMMMMMMMs
${c1}         `hMMMMMMd/          /dMMMMMMh
${c1}           `://:`              `://:`
EOF
