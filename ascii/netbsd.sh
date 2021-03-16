# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 60
if [ "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'orange') # Orange
	c2=$(getColor 'white') # White
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}                                  __,gnnnOCCCCCOObaau,_
${c2}   _._                    ${c1}__,gnnCCCCCCCCOPF"''
${c2}  (N${c1}XCbngg,._____.,gnnndCCCCCCCCCCCCF"___,,,,___
${c2}   N${c1}XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCOOOOPYvv.
${c2}    N${c1}XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCPF"''
${c2}     N${c1}XCCCCCCCCCCCCCCCCCCCCCCCCCOF"'
${c2}      N${c1}XCCCCCCCCCCCCCCCCCCCCOF"'
${c2}       N${c1}XCCCCCCCCCCCCCCCPF"'
${c2}        N${c1}"PCOCCCOCCFP""
${c2}         N
${c2}          N
${c2}           N
${c2}            NN
${c2}             NN
${c2}              NNA.
${c2}               NNA,
${c2}                NNN,
${c2}                 NNN
${c2}                  NNN
${c2}                   NNNA
EOF
