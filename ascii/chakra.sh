# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 38
# number of colors: 1
if [ "${config_text[color]}" == "off" ]; then
c1=$(getColor 'light blue') # Light Blue
fi
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}      _ _ _        "kkkkkkkk.
${c1}    ,kkkkkkkk.,    'kkkkkkkkk,
${c1}    ,kkkkkkkkkkkk., 'kkkkkkkkk.
${c1}   ,kkkkkkkkkkkkkkkk,'kkkkkkkk,
${c1}  ,kkkkkkkkkkkkkkkkkkk'kkkkkkk.
${c1}   "''"''',;::,,"''kkk''kkkkk;   __
${c1}       ,kkkkkkkkkk, "k''kkkkk' ,kkkk
${c1}     ,kkkkkkk' ., ' .: 'kkkk',kkkkkk
${c1}   ,kkkkkkkk'.k'   ,  ,kkkk;kkkkkkkkk
${c1}  ,kkkkkkkk';kk 'k  "'k',kkkkkkkkkkkk
${c1} .kkkkkkkkk.kkkk.'kkkkkkkkkkkkkkkkkk'
${c1} ;kkkkkkkk''kkkkkk;'kkkkkkkkkkkkk''
${c1} 'kkkkkkk; 'kkkkkkkk.,""''"''""
${c1}   ''kkkk;  'kkkkkkkkkk.,
${c1}      ';'    'kkkkkkkkkkkk.,
${c1}              ';kkkkkkkkkk'
${c1}                ';kkkkkk'
${c1}                   "''"
EOF
