# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 32
# number of colors: 2
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'white') # White
c2=$(getColor 'light red') # Light Red
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}         _,met\$\$\$\$\$gg.
${c1}      ,g\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$P.
${c1}    ,g\$\$P\"\"       \"\"\"Y\$\$.\".
${c1}   ,\$\$P'              \`\$\$\$.
${c1}  ',\$\$P       ,ggs.     \`\$\$b:
${c1}  \`d\$\$'     ,\$P\"\'   ${c2}.${c1}    \$\$\$
${c1}   \$\$P      d\$\'     ${c2},${c1}    \$\$P
${c1}   \$\$:      \$\$.   ${c2}-${c1}    ,d\$\$'
${c1}   \$\$\;      Y\$b._   _,d\$P'
${c1}   Y\$\$.    ${c2}\`.${c1}\`\"Y\$\$\$\$P\"'
${c1}   \`\$\$b      ${c2}\"-.__
${c1}    \`Y\$\$
${c1}     \`Y\$\$.
${c1}       \`\$\$b.
${c1}         \`Y\$\$b.
${c1}            \`\"Y\$b._
${c1}                \`\"\"\"\"
${c1}
EOF
