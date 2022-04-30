# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 34
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
    c1=$(getColor 'white')     # White
    c2=$(getColor 'light red') # Light Red
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c2}              ,        ,
${c2}             /(        )`
${c2}              ___   / |
${c2}             /- ${c1}_${c2}  `-/  '
${c2}            (${c1}//  ${c2}   /
${c1}            / /   |${c2} `    
${c1}            O O   )${c2} /    |
${c1}            `-^--'`${c2}<     '
${c2}           (_.)  _  )   /
${c2}            `.___/`    /
${c2}              `-----' /
${c1} <----.     ${c2}__/ __   
${c1} <----|====${c2}O}}}${c1}==${c2}} } /${c1}====
${c1} <----'    ${c2}`--' `.__,' 
${c2}              |        |
${c2}                      /       /
${c2}          ______( (_  / ______/
${c2}        ,'  ,-----'   |
${c2}        `--{__________)
${c2}
EOF
