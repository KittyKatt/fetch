# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo widht: 52
# number of colors: 2
if [ ! "${config_text[color]}" == "off" ]; then
  c1=$(getColor 'white')        # White
  c2=$(getColor 'light purple') # Light Purple
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}
${c1}
${c1}
${c1}
${c1}     _______               ____
${c1}    /MMMMMMM/             /MMMM| _____  _____
${c1} __/M${c2}.MMM.${c1}M/_____________|M${c2}.M${c1}MM|/MMMMM/MMMMM
${c1}|MMMM${c2}MM'${c1}MMMMMMMMMMMMMMMMMMM${c2}MM${c1}MMMM${c2}.MMMM..MMMM.${c1}MM
${c1}|MM${c2}MMMMMMM${c1}/m${c2}MMMMMMMMMMMMMMMMMMMMMM${c1}MMMM${c2}MM${c1}MMMM${c2}MM${c1}MM|
${c1}|MMMM${c2}MM${c1}MMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MMMMM${c2}MMM${c1}MMM${c2}MM${c1}MMMM${c2}MM${c1}MMMM${c2}MM${c1}MM|
${c1}  |MM${c2}MM${c1}MMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MMM${c1}MMMM${c2}'MMMM''MMMM'${c1}MM/
${c1}  |MM${c2}MM${c1}MMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MMM${c1}MMMMMMMM/MMMMM/
${c1}  |MM${c2}MM${c1}MMM${c2}MM${c1}MMMMMM${c2}MM${c1}MM${c2}MM${c1}MM${c2}MMMMM'${c1}M|
${c1}  |MM${c2}MM${c1}MMM${c2}MMMMMMMMMMMMMMMMM MM'${c1}M/
${c1}  |MMMMMMMMMMMMMMMMMMMMMMMMMMMM/
${c1}
${c1}
${c1}
EOF
