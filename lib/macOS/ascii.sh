case "${my_distro}" in
    # logo width: 31
    # number of colors: 6
    *"Mac OS X"*|*"macOS"*s)
        c1=$(getColor 'green') # Green
        c2=$(getColor 'brown') # Yellow
        c3=$(getColor 'light red') # Orange
        c4=$(getColor 'red') # Red
        c5=$(getColor 'purple') # Purple
        c6=$(getColor 'blue') # Blue
        startline=1
		read -rd '' asciiLogo <<'EOF'
${c1}
${c1}                 -/+:.
${c1}                :++++.
${c1}               /+++/.
${c1}       .:-::- .+/:-``.::-
${c1}    .:/++++++/::::/++++++/:`
${c2}  .:///////////////////////:`
${c2}  ////////////////////////`
${c3} -+++++++++++++++++++++++`
${c3} /++++++++++++++++++++++/
${c4} /sssssssssssssssssssssss.
${c4} :ssssssssssssssssssssssss-
${c5}  osssssssssssssssssssssssso/`
${c5}  `syyyyyyyyyyyyyyyyyyyyyyyy+`
${c6}   `ossssssssssssssssssssss/
${c6}     :ooooooooooooooooooo+.
${c6}      `:+oo+/:-..-:/+o+/-
${c6}
EOF
        ;;
    # logo width: 39
    # number of colors: 4
    "Mac - Classic")
        c1=$(getColor 'blue') # Blue
        c2=$(getColor 'light blue') # Light blue
        c3=$(getColor 'light grey') # Gray
        c4=$(getColor 'dark grey') # Dark Ggray
        startline=1
		read -rd '' asciiLogo <<'EOF'
${c3}
${c3}                        ..
${c3}                       dWc
${c3}                     ,X0'
${c1}  ;;;;;;;;;;;;;;;;;;${c3}0Mk${c2}:::::::::::::::
${c1}  ;;;;;;;;;;;;;;;;;${c3}KWo${c2}::::::::::::::::
${c1}  ;;;;;;;;;${c4}NN${c1};;;;;${c3}KWo${c2}:::::${c3}NN${c2}::::::::::
${c1}  ;;;;;;;;;${c4}NN${c1};;;;${c3}0Md${c2}::::::${c3}NN${c2}::::::::::
${c1}  ;;;;;;;;;${c4}NN${c1};;;${c3}xW0${c2}:::::::${c3}NN${c2}::::::::::
${c1}  ;;;;;;;;;;;;;;${c3}KMc${c2}:::::::::::::::::::
${c1}  ;;;;;;;;;;;;;${c3}lWX${c2}::::::::::::::::::::
${c1}  ;;;;;;;;;;;;;${c3}xWWXXXXNN7${c2}:::::::::::::
${c1}  ;;;;;;;;;;;;;;;;;;;;${c3}WK${c2}::::::::::::::
${c1}  ;;;;;${c4}TKX0ko.${c1};;;;;;;${c3}kMx${c2}:::${c3}.cOKNF${c2}:::::
${c1}  ;;;;;;;;${c4}`kO0KKKKKKK${c3}NMNXK0OP*${c2}::::::::
${c1}  ;;;;;;;;;;;;;;;;;;;${c3}kMx${c2}::::::::::::::
${c1}  ;;;;;;;;;;;;;;;;;;;;${c3}WX${c2}::::::::::::::
${c3}                      lMc
${c3}                       kN.
${c3}                        o'
${c3}
EOF
        ;;
esac