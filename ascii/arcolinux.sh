# logo width: 41
# number of colors: 2
c1=$(getColor 'arco_blue') # dark
c2=$(getColor 'white') # light
startline="1"
read -rd '' asciiLogo <<'EOF'
${c1}                    /-
${c1}                   ooo:     
${c1}                  yoooo/
${c1}                 yooooooo
${c1}                yooooooooo 
${c1}               yooooooooooo
${c1}             .yooooooooooooo
${c1}            .oooooooooooooooo
${c1}           .oooooooarcoooooooo
${c1}          .ooooooooo-oooooooooo   
${c1}         .ooooooooo-  oooooooooo
${c1}        :ooooooooo.    :ooooooooo
${c1}       :ooooooooo.      :ooooooooo
${c1}      :oooarcooo         .oooarcooo  
${c1}     :ooooooooy           .ooooooooo 
${c1}    :ooooooooo   ${c2}/ooooooooooooooooooo${c1}
${c1}   :ooooooooo      ${c2}.-ooooooooooooooooo.${c1}   
${c1}  ooooooooo-             ${c2}-ooooooooooooo.${c1}    
${c1} ooooooooo-                 ${c2}.-oooooooooo.${c1}   
${c1}ooooooooo.                     ${c2}-ooooooooo${c1}
EOF