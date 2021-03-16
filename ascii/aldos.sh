# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'light grey') # light grey
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}           # ## #
${c1}        # ######## #
${c1}      # ### ######## #
${c1}     # #### ######### #
${c1}   # #### # # # # #### #
${c1}  # ##### #       ##### #
${c1}   # ###### ##### #### #
${c1}    # ############### #
${c1}
${c2}        _ ___   ___  ___
${c2}   __ _| |   \ / _ \/ __|
${c2}  / _' | | |) | (_) \__ \
${c2}  \__,_|_|___/ \___/|___/
${c1}
${c1}
EOF
