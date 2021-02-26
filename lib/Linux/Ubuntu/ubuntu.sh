# number of colors: 3
# logo width: 38
if [[ "$no_color" != "1" ]]; then
	[[ -n "${c1}" ]] && c1=$(getColor 'fg') # White
	[[ -n "${c1}" ]] && c2=$(getColor 'light red') # Light Red
	[[ -n "${c1}" ]] && c3=$(getColor 'yellow') # Bold Yellow
fi
startline="0"
logowidth="38"
asciiLogo=(
"${c2}                          ./+o+-      %s"
"${c1}                  yyyyy- ${c2}-yyyyyy+     %s"
"${c1}               ${c1}://+//////${c2}-yyyyyyo     %s"
"${c3}           .++ ${c1}.:/++++++/-${c2}.+sss/\`     %s"
"${c3}         .:++o:  ${c1}/++++++++/:--:/-     %s"
"${c3}        o:+o+:++.${c1}\`..\`\`\`.-/oo+++++/    %s"
"${c3}       .:+o:+o/.${c1}          \`+sssoo+/   %s"
"${c1}  .++/+:${c3}+oo+o:\`${c1}             /sssooo.  %s"
"${c1} /+++//+:${c3}\`oo+o${c1}               /::--:.  %s"
"${c1} \+/+o+++${c3}\`o++o${c2}               ++////.  %s"
"${c1}  .++.o+${c3}++oo+:\`${c2}             /dddhhh.  %s"
"${c3}       .+.o+oo:.${c2}          \`oddhhhh+   %s"
"${c3}        \+.++o+o\`${c2}\`-\`\`\`\`.:ohdhhhhh+    %s"
"${c3}         \`:o+++ ${c2}\`ohhhhhhhhyo++os:     %s"
"${c3}           .o:${c2}\`.syhhhhhhh/${c3}.oo++o\`     %s"
"${c2}               /osyyyyyyo${c3}++ooo+++/    %s"
"${c2}                   \`\`\`\`\` ${c3}+oo+++o\:    %s"
"${c3}                          \`oo++.      %s")