# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 45
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'yellow') # Light Yellow
	c2=$(getColor 'light gray') # Light Gray
fi
startline="1"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}   .smNdy+-    `.:/osyyso+:.`    -+ydmNs.
${c1}  /Md- -/ymMdmNNdhso/::/oshdNNmdMmy/. :dM/
${c1}  mN.     oMdyy- -y          `-dMo     .Nm
${c1}  .mN+`  sMy hN+ -:             yMs  `+Nm.
${c1}   `yMMddMs.dy `+`               sMddMMy`
${c1}     +MMMo  .`  .                 oMMM+
${c1}     `NM/    `````.`    `.`````    +MN`
${c1}     yM+   `.-:yhomy    ymohy:-.`   +My
${c1}     yM:          yo    oy          :My
${c1}     +Ms         .N`    `N.      +h sM+
${c1}     `MN      -   -::::::-   : :o:+`NM`
${c1}      yM/    sh   -dMMMMd-   ho  +y+My
${c1}      .dNhsohMh-//: /mm/ ://-yMyoshNd`
${c1}        `-ommNMm+:/. oo ./:+mMNmmo:`
${c1}       `/o+.-somNh- :yy: -hNmos-.+o/`
${c1}      ./` .s/`s+sMdd+``+ddMs+s`/s. `/.
${c1}          : -y.  -hNmddmNy.  .y- :
${c1}           -+       `..`       +-
${c1}
EOF
