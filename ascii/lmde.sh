# logo width: 31
# number of colors: 2
c1=$(getColor 'white') # White
c2=$(getColor 'light green') # Bold Green
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}          `.-::---..
${c2}       .:++++ooooosssoo:.
${c2}     .+o++::.      `.:oos+.
${c2}    :oo:.`             -+oo${c1}:
${c2}  ${c1}`${c2}+o/`    .${c1}::::::${c2}-.    .++-${c1}`
${c2} ${c1}`${c2}/s/    .yyyyyyyyyyo:   +o-${c1}`
${c2} ${c1}`${c2}so     .ss       ohyo` :s-${c1}:
${c2} ${c1}`${c2}s/     .ss  h  m  myy/ /s`${c1}`
${c2} `s:     `oo  s  m  Myy+-o:`
${c2} `oo      :+sdoohyoydyso/.
${c2}  :o.      .:////////++:
${c2}  `/++        ${c1}-:::::-
${c2}   ${c1}`${c2}++-
${c2}    ${c1}`${c2}/+-
${c2}      ${c1}.${c2}+/.
${c2}        ${c1}.${c2}:+-.
${c2}           `--.``
${c2}
EOF