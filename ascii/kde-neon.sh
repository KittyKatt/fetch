# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 43
# number of colors: 1
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light green') # Light Green
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}              `..---+/---..`
${c1}          `---.``   ``   `.---.`
${c1}       .--.`        ``        `-:-.
${c1}     `:/:     `.----//----.`     :/-
${c1}    .:.    `---`          `--.`    .:`
${c1}   .:`   `--`                .:-    `:.
${c1}  `/    `:.      `.-::-.`      -:`   `/`
${c1}  /.    /.     `:++++++++:`     .:    .:
${c1} `/    .:     `+++++++++++/      /`   `+`
${c1} /+`   --     .++++++++++++`     :.   .+:
${c1} `/    .:     `+++++++++++/      /`   `+`
${c1}  /`    /.     `:++++++++:`     .:    .:
${c1}  ./    `:.      `.:::-.`      -:`   `/`
${c1}   .:`   `--`                .:-    `:.
${c1}    .:.    `---`          `--.`    .:`
${c1}     `:/:     `.----//----.`     :/-
${c1}       .-:.`        ``        `-:-.
${c1}          `---.``   ``   `.---.`
${c1}              `..---+/---..`
EOF