# number of colors: 2
# logo width: 37
c1=$(getColor 'white') # White
c2=$(getColor 'light blue') # Light Blue
startline=0
read -rd '' asciiLogo <<'EOF'
${c2}           /:-------------:\
${c2}        :-------------------::
${c2}      :-----------${c1}/shhOHbmp${c2}---:\
${c2}    /-----------${c1}omMMMNNNMMD  ${c2}---:
${c2}   :-----------${c1}sMMMMNMNMP${c2}.    ---:
${c2}  :-----------${c1}:MMMdP${c2}-------    ---\
${c2} ,------------${c1}:MMMd${c2}--------    ---:
${c2} :------------${c1}:MMMd${c2}-------    .---:
${c2} :----    ${c1}oNMMMMMMMMMNho${c2}     .----:
${c2} :--     .${c1}+shhhMMMmhhy++${c2}   .------/
${c2} :-    -------${c1}:MMMd${c2}--------------:
${c2} :-   --------${c1}/MMMd${c2}-------------;
${c2} :-    ------${c1}/hMMMy${c2}------------:
${c2} :--${c1} :dMNdhhdNMMNo${c2}------------;
${c2} :---${c1}:sdNMMMMNds:${c2}------------:
${c2} :------${c1}:://:${c2}-------------::
${c2} :---------------------://
${c2}
EOF