# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 27
# number of colors: 3
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'light cyan') # Light Cyan
  c2=$(getColor 'yellow')     # Yellow
  c3=$(getColor 'white')      # White
fi
startline="1"
read -rd '' asciiLogo << 'EOF'
${c1}          odddd
${c1}       oddxkkkxxdoo
${c1}      ddcoddxxxdoool
${c1}      xdclodod  olol
${c1}      xoc  xdd  olol
${c1}      xdc  ${c2}k00${c1}Okdlol
${c1}      xxd${c2}kOKKKOkd${c1}ldd
${c1}      xdco${c2}xOkdlo${c1}dldd
${c1}      ddc:cl${c2}lll${c1}oooodo
${c1}    odxxdd${c3}xkO000kx${c1}ooxdo
${c1}   oxdd${c3}x0NMMMMMMWW0od${c1}kkxo
${c1}  oooxd${c3}0WMMMMMMMMMW0o${c1}dxkx
${c1} docldkXW${c3}MMMMMMMWWN${c1}Odolco
${c1} xx${c2}dx${c1}kxxOKN${c3}WMMWN${c1}0xdoxo::c
${c2} xOkkO${c1}0oo${c3}odOW${c2}WW${c1}XkdodOxc:l
${c2} dkkkxkkk${c3}OKX${c2}NNNX0Oxx${c1}xc:cd
${c2}  odxxdx${c3}xllod${c2}ddooxx${c1}dc:ldo
${c2}    lodd${c1}dolccc${c2}ccox${c1}xoloo
${c1}
EOF
