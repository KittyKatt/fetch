# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 31
# number of colors: 6
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'green')     # Green
  c2=$(getColor 'brown')     # Yellow
  c3=$(getColor 'light red') # Light Red
  c4=$(getColor 'red')       # Red
  c5=$(getColor 'purple')    # Purple
  c6=$(getColor 'blue')      # Blue
fi
startline=1
read -rd '' asciiLogo << 'EOF'
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
