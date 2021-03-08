# logo width: 37
# number of colors: 4
c1=$(getColor 'light red') # Red
c2=$(getColor 'light green') # Green
c3=$(getColor 'light blue') # Blue
c4=$(getColor 'yellow') # Yellow
startline=1
read -rd '' asciiLogo <<'EOF'
${c1}        ,.=:!!t3Z3z.,
${c1}       :tt:::tt333EE3
${c1}       Et:::ztt33EEEL${c2} @Ee.,      ..,
${c1}      ;tt:::tt333EE7${c2} ;EEEEEEttttt33#
${c1}     :Et:::zt333EEQ.${c2} $EEEEEttttt33QL
${c1}     it::::tt333EEF${c2} @EEEEEEttttt33F
${c1}    ;3=*^```"*4EEV${c2} :EEEEEEttttt33@.
${c3}    ,.=::::!t=., ${c1}`${c2} @EEEEEEtttz33QF
${c3}   ;::::::::zt33)${c2}   "4EEEtttji3P*
${c3}  :t::::::::tt33.${c4}:Z3z..${c2}  ``${c4} ,..g.
${c3}  i::::::::zt33F${c4} AEEEtttt::::ztF
${c3} ;:::::::::t33V${c4} ;EEEttttt::::t3
${c3} E::::::::zt33L${c4} @EEEtttt::::z3F
${c3}{3=*^```"*4E3)${c4} ;EEEtttt:::::tZ`
${c3}             `${c4} :EEEEtttt::::z7
${c4}                 "VEzjt:;;z>*`
EOF