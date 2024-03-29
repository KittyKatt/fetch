# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 40
# number of colors: 2
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'white')     # White
  c2=$(getColor 'light red') # Light Red
fi
startline="3"
read -rd '' asciiLogo << 'EOF'
${c2}             PPPPPPPPPPPPPP
${c2}         PPPP${c1}MMMMMMM${c2}PPPPPPPPPPP
${c2}       PPPP${c1}MMMMMMMMMM${c2}PPPPPPPP${c1}MM${c2}PP
${c2}     PPPPPPPP${c1}MMMMMMM${c2}PPPPPPPP${c1}MMMMM${c2}PP
${c2}   PPPPPPPPPPPP${c1}MMMMMM${c2}PPPPPPP${c1}MMMMMMM${c2}PP
${c2}  PPPPPPPPPPPP${c1}MMMMMMM${c2}PPPP${c1}M${c2}P${c1}MMMMMMMMM${c2}PP
${c2} PP${c1}MMMM${c2}PPPPPPPPPP${c1}MMM${c2}PPPPP${c1}MMMMMMM${c2}P${c1}MM${c2}PPPP
${c2} P${c1}MMMMMMMMMM${c2}PPPPPP${c1}MM${c2}PPPPP${c1}MMMMMM${c2}PPPPPPPP
${c2}P${c1}MMMMMMMMMMMM${c2}PPPPP${c1}MM${c2}PP${c1}M${c2}P${c1}MM${c2}P${c1}MM${c2}PPPPPPPPPPP
${c2}P${c1}MMMMMMMMMMMMMMMM${c2}PP${c1}M${c2}P${c1}MMM${c2}PPPPPPPPPPPPPPPP
${c2}P${c1}MMM${c2}PPPPPPPPPPPPPPPPPPPPPPPPPPPPPP${c1}MMMMM${c2}P
${c2}PPPPPPPPPPPPPPPP${c1}MMM${c2}P${c1}M${c2}P${c1}MMMMMMMMMMMMMMMM${c2}PP
${c2}PPPPPPPPPPP${c1}MM${c2}P${c1}MM${c2}PPPP${c1}MM${c2}PPPPP${c1}MMMMMMMMMMM${c2}PP
${c2} PPPPPPPP${c1}MMMMMM${c2}PPPPP${c1}MM${c2}PPPPPP${c1}MMMMMMMMM${c2}PP
${c2} PPPP${c1}MM${c2}P${c1}MMMMMMM${c2}PPPPPP${c1}MM${c2}PPPPPPPPPP${c1}MMMM${c2}PP
${c2}  PP${c1}MMMMMMMMM${c2}P${c1}M${c2}PPPP${c1}MMMMMM${c2}PPPPPPPPPPPPP
${c2}   PP${c1}MMMMMMM${c2}PPPPPPP${c1}MMMMMM${c2}PPPPPPPPPPPP
${c2}     PP${c1}MMMM${c2}PPPPPPPPP${c1}MMMMMMM${c2}PPPPPPPP
${c2}       PP${c1}MM${c2}PPPPPPPP${c1}MMMMMMMMMM${c2}PPPP
${c2}         PPPPPPPPPP${c1}MMMMMMMM${c2}PPPP
${c2}             PPPPPPPPPPPPPP
EOF
