case ${my_distro} in
	Ubuntu)
		# number of colors: 3
		# logo width: 38
		if [ "${no_color}" != "1" ]; then
			c1=$(getColor 'fg') # White
			c2=$(getColor 'light red') # Light Red
			c3=$(getColor 'yellow') # Bold Yellow
		fi
		startline=0
		logowidth=38
		read -rd '' asciiLogo <<'EOF'
${c2}                          ./+o+-
${c1}                  yyyyy- ${c2}-yyyyyy+
${c1}               ${c1}://+//////${c2}-yyyyyyo
${c3}           .++ ${c1}.:/++++++/-${c2}.+sss/`
${c3}         .:++o:  ${c1}/++++++++/:--:/-
${c3}        o:+o+:++.${c1}`..```.-/oo+++++/
${c3}       .:+o:+o/.${c1}          `+sssoo+/
${c1}  .++/+:${c3}+oo+o:`${c1}             /sssooo.
${c1} /+++//+:${c3}`oo+o${c1}               /::--:.
${c1} +/+o+++${c3}`o++o${c2}               ++////.
${c1}  .++.o+${c3}++oo+:`${c2}             /dddhhh.
${c3}       .+.o+oo:.${c2}          `oddhhhh+
${c3}        +.++o+o`${c2}`-````.:ohdhhhhh+
${c3}         `:o+++ ${c2}`ohhhhhhhhyo++os:
${c3}           .o:${c2}`.syhhhhhhh/${c3}.oo++o`
${c2}               /osyyyyyyo${c3}++ooo+++/
${c2}                   ````` ${c3}+oo+++o:
${c3}                          `oo++.
EOF
		;;
	*) : ;;
esac