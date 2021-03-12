# logo width: 50
c1=$(getColor 'blue') # Blue
c2=$(getColor 'light grey') # White
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}                                             <NNN>
${c1}                                           <NNY
${c1}                 <ooooo>--.               ((
${c1}               Aoooooooooooo>--.           
${c1}              AooodNNNNNNNNNNNNNNNN>--.     ))
${c2}          (${c1}  AoodNNNNNNNNNNNNNNNNNNNNNNN>-///'
${c2}          ${c1}AodNNNNNNNNNNNNNNNNNNNNNNNNNNNY/
${c1}           AodNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
${c1}          AdNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNA
${c1}         (${c2}/)${c1}NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNA
${c2}         //${c1}<NNNNNNNNNNNNNNNNNY'   YNNY YNNNN
${c2} ,====#Y//${c1}   `<NNNNNNNNNNNY       ANY     YNA
${c1}               ANY<NNNNYYN       .NY        YN.
${c1}             (NNY       NN      (NND       (NND
${c1}                      (NNU
${c1}
EOF