# logo width: 40
# number of colors: 1
c1=$(getColor 'light blue') # Light Blue
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}           ...................
${c1}          :ooooooooooooooooooo/
${c1}         /ooooooooooooooooooooo+
${c1}        ''''''''''''''''''''''''
${c1}
${c1}    .++++++++++++++++++/.       :++-
${c1}   -oooooooooooooooo/-       :+ooooo:
${c1}  :oooooooooooooo/-       :+ooooooooo:
${c1} .oooooooooooo+-       :+ooooooooooooo-
${c1}  -oooooooo/-       -+ooooooooooooooo:
${c1}   .oooo+-       -+ooooooooooooooooo-
${c1}    .--        .-------------------.
${c1}
${c1}        .//////////////////////-
${c1}         :oooooooooooooooooooo/
${c1}          :oooooooooooooooooo:
${c1}           ''''''''''''''''''
EOF