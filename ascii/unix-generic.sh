# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 44
# number of colors: 1
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'light green') # Light Green
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c1}
${c1}
${c1}
${c1} UUU     UUU NNN      NNN IIIII XXX     XXXX
${c1} UUU     UUU NNNN     NNN  III    XX   xXX
${c1} UUU     UUU NNNNN    NNN  III     XX xXX
${c1} UUU     UUU NNN NN   NNN  III      XXXX
${c1} UUU     UUU NNN  NN  NNN  III      xXX
${c1} UUU     UUU NNN   NN NNN  III     xXXXX
${c1} UUU     UUU NNN    NNNNN  III    xXX  XX
${c1}  UUUuuuUUU  NNN     NNNN  III   xXX    XX
${c1}    UUUUU    NNN      NNN IIIII xXXx    xXXx
${c1}
${c1}
${c1}
EOF
