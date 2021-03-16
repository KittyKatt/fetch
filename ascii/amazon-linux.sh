# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 40
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light orange') # Orange
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}               .,:cc:,.
${c1}          .:okXWMMMMMMWXko:.
${c1}      .:kNMMMMMMMMMMMMMMMMMMNkc.
${c1}   cc,.    `':ox0XWWXOxo:'`    .,c;
${c1}   KMMMMXOdc,.    ''    .,cdOXWMMMO
${c1}   KMMMMMMMMMMWXO.  .OXWMMMMMMMMMMO
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMO
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMk
${c1}   KMMMMMMMMMMMMM,  ,MMMMMMMMMMMMMd
${c1}   `:lx0WMMMMMMMM,  ,MMMMMMMMW0xl:`
${c1}         `'lx0NMM,  ,MMN0xc'`
${c1}               `''  ''`
EOF
