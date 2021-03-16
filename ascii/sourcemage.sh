# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 40
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'dark gray')
fi
startline="1"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}       -sdNMNds:
${c1} .shmNMMMMMMNNNNh.
${c1}  ` ':sNNNNNNNNNNm-
${c1}      .NNNNNNmmmmmdo.
${c1}     -mNmmmmmmmmmmddd:
${c1}     +mmmmmmmddddddddh-
${c1}     :mmdddddddddhhhhhy.
${c1}     -ddddddhhhhhhhhyyyo
${c1}     .hyhhhhhhhyyyyyyyys:
${c1}      .`shyyyyyyyyyssssso
${c1}        `/yyyysssssssoooo.
${c1}          .osssssooooo+++/
${c1}           `:+oooo+++++///.
${c1}            `://++//////::-
${c1}        ..-///  .//::::::--.
${c1}       ```` ```  :::--------`
${c1}                 `------....`
${c1}                  `.........`
${c1}                  `......`
EOF
