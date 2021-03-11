# logo width: 37
# number of colors: 2
c1=$(getColor 'white') # white
c2=$(getColor 'light red') # Light Red
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}   ```                        ${c2}`
${c1}  ` `.....---...${c2}....--.```   -/
${c1}  +o   .--`         ${c2}/y:`      +.
${c1}   yo`:.            ${c2}:o      `+-
${c1}    y/               ${c2}-/`   -o/
${c1}   .-                  ${c2}::/sy+:.
${c1}   /                     ${c2}`--  /
${c1}  `:                          ${c2}:`
${c1}  `:                          ${c2}:`
${c1}   /                          ${c2}/
${c1}   .-                        ${c2}-.
${c1}    --                      ${c2}-.
${c1}     `:`                  ${c2}`:`
${c2}       .--             `--.
${c2}          .---.....----.
${c2}
${c2}
EOF