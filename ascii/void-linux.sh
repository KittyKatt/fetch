# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 47
# number of colors: 3
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'green')       # Green
  c2=$(getColor 'light green') # Light Green
  c3=$(getColor 'dark grey')   # Dark Grey
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c2}                 __.;=====;.__
${c2}             _.=+==++=++=+=+===;.
${c2}              -=+++=+===+=+=+++++=_
${c1}         .     ${c2}-=:``     `--==+=++==.
${c1}        _vi,    ${c2}`            --+=++++:
${c1}       .uvnvi.       ${c2}_._       -==+==+.
${c1}      .vvnvnI`    ${c2}.;==|==;.     :|=||=|.
${c3} +QmQQm${c1}pvvnv; ${c3}_yYsyQQWUUQQQm #QmQ#${c2}:${c3}QQQWUV$QQmL
${c3}  -QQWQW${c1}pvvo${c3}wZ?.wQQQE${c2}==<${c3}QWWQ/QWQW.QQWW${c2}(: ${c3}jQWQE
${c3}   -$QQQQmmU'  jQQQ@${c2}+=<${c3}QWQQ)mQQQ.mQQQC${c2}+;${c3}jWQQ@'
${c3}    -$WQ8Y${c1}nI:   ${c3}QWQQwgQQWV${c2}`${c3}mWQQ.jQWQQgyyWW@!
${c1}      -1vvnvv.     ${c2}`~+++`        ++|+++
${c1}       +vnvnnv,                 ${c2}`-|===
${c1}        +vnvnvns.           .      ${c2}:=-
${c1}         -Invnvvnsi..___..=sv=.     ${c2}`
${c1}           +Invnvnvnnnnnnnnvvnn;.
${c1}             ~|Invnvnvvnvvvnnv}+`
${c1}                -~"|{*l}*|""~
EOF
