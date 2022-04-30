# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 37
# number of colors: 2
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'white')      # White
  c2=$(getColor 'light blue') # Light Blue
fi
startline=0
read -rd '' asciiLogo << 'EOF'
${c2}             .',;::::;,'.
${c2}         .';:cccccccccccc:;,.
${c2}      .;cccccccccccccccccccccc;.
${c2}    .:cccccccccccccccccccccccccc:.
${c2}  .;ccccccccccccc;${c1}.:dddl:.${c2};ccccccc;.
${c2} .:ccccccccccccc;${c1}OWMKOOXMWd${c2};ccccccc:.
${c2}.:ccccccccccccc;${c1}KMMc${c2};cc;${c1}xMMc${c2}:ccccccc:.
${c2},cccccccccccccc;${c1}MMM.${c2};cc;${c1};WW:${c2}:cccccccc,
${c2}:cccccccccccccc;${c1}MMM.${c2};cccccccccccccccc:
${c2}:ccccccc;${c1}oxOOOo${c2};${c1}MMM0OOk.${c2};cccccccccccc:
${c2}cccccc:${c1}0MMKxdd:${c2};${c1}MMMkddc.${c2};cccccccccccc;
${c2}ccccc:${c1}XM0'${c2};cccc;${c1}MMM.${c2};cccccccccccccccc'
${c2}ccccc;${c1}MMo${c2};ccccc;${c1}MMW.${c2};ccccccccccccccc;
${c2}ccccc;${c1}0MNc.${c2}ccc${c1}.xMMd${c2}:ccccccccccccccc;
${c2}cccccc;${c1}dNMWXXXWM0:${c2}:cccccccccccccc:,
${c2}cccccccc;${c1}.:odl:.${c2};cccccccccccccc:,.
${c2}:cccccccccccccccccccccccccccc:'.
${c2}.:cccccccccccccccccccccc:;,..
${c2}  '::cccccccccccccc::;,.
${c2}
EOF
