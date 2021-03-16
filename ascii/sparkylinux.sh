# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 48
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light gray') # Gray
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}             .            `-:-`
${c1}            .o`       .-///-`
${c1}           `oo`    .:/++:.
${c1}           os+`  -/+++:` ``.........```
${c1}          /ys+`./+++/-.-::::::----......``
${c1}         `syyo`++o+--::::-::/+++/-``
${c1}         -yyy+.+o+`:/:-:sdmmmmmmmmdy+-`
${c1}  ::-`   :yyy/-oo.-+/`ymho++++++oyhdmdy/`
${c1}  `/yy+-`.syyo`+o..o--h..osyhhddhs+//osyy/`
${c1}    -ydhs+-oyy/.+o.-: ` `  :/::+ydhy+```-os-
${c1}     .sdddy::syo--/:.     `.:dy+-ohhho    ./:
${c1}       :yddds/:+oo+//:-`- /+ +hy+.shhy:     ``
${c1}        `:ydmmdysooooooo-.ss`/yss--oyyo
${c1}          `./ossyyyyo+:-/oo:.osso- .oys
${c1}         ``..-------::////.-oooo/   :so
${c1}      `...----::::::::--.`/oooo:    .o:
${c1}             ```````     ++o+:`     `:`
${c1}                       ./+/-`        `
${c1}                     `-:-.
${c1}                     ``
EOF
