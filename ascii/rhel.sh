# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 42
# number of colors: 1
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'light red') # Light Red
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}            .MMM..:MMMMMMM
${c1}           MMMMMMMMMMMMMMMMMM
${c1}           MMMMMMMMMMMMMMMMMMMM.
${c1}          MMMMMMMMMMMMMMMMMMMMMM
${c1}         ,MMMMMMMMMMMMMMMMMMMMMM:
${c1}         MMMMMMMMMMMMMMMMMMMMMMMM
${c1}   .MMMM'  MMMMMMMMMMMMMMMMMMMMMM
${c1}  MMMMMM    `MMMMMMMMMMMMMMMMMMMM.
${c1} MMMMMMMM      MMMMMMMMMMMMMMMMMM .
${c1} MMMMMMMMM.       `MMMMMMMMMMMMM' MM.
${c1} MMMMMMMMMMM.                     MMMM
${c1} `MMMMMMMMMMMMM.                 ,MMMMM.
${c1}  `MMMMMMMMMMMMMMMMM.          ,MMMMMMMM.
${c1}     MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
${c1}       MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM:
${c1}          MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
${c1}             `MMMMMMMMMMMMMMMMMMMMMMMM:
${c1}                 ``MMMMMMMMMMMMMMMMM'
EOF
