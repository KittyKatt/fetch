# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 39
# number of colors: 1
# TODO: this logo is vertically huge. Condense, perhaps?
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light blue') # Light Blue
fi
startline="3"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}           DZZZZZZZZZZZZZ 
${c1}         ZZZZZZZZZZZZZZZZZZZ
${c1}          ZZZZZZZZZZZZZZZZZZZZ
${c1}           OZZZZZZZZZZZZZZZZZZZZ
${c1}   Z         ZZZ    8ZZZZZZZZZZZZ 
${c1}  ZZZ                   ZZZZZZZZZZ
${c1} ZZZZZN                   ZZZZZZZZZ
${c1} ZZZZZZZ                    ZZZZZZZZ
${c1}ZZZZZZZZ                    OZZZZZZZ
${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
${c1}ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
${c1}ZZZZZZZZ
${c1} ZZZZZZZZ
${c1} OZZZZZZZZO
${c1}  ZZZZZZZZZZZ
${c1}   OZZZZZZZZZZZZZZZN
${c1}     ZZZZZZZZZZZZZZZZ
${c1}      DZZZZZZZZZZZZZZZ
${c1}         ZZZZZZZZZZZZZ
${c1}            NZZZZZZZZ
${c1}
EOF