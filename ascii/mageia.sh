# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 3
# number of colors: 2
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor 'white')      # White
  c2=$(getColor 'light cyan') # Light Cyan
fi
startline="0"
read -rd '' asciiLogo << 'EOF'
${c2}               .°°.
${c2}                °°   .°°.
${c2}                .°°°. °°
${c2}                .   .
${c2}                 °°° .°°°.
${c2}             .°°°.   '___'
${c1}            .${c2}'___'     ${c1}   .
${c1}          :dkxc;'.  ..,cxkd;
${c1}        .dkk. kkkkkkkkkk .kkd.
${c1}       .dkk.  ';cloolc;.  .kkd
${c1}       ckk.                .kk;
${c1}       xO:                  cOd
${c1}       xO:                  lOd
${c1}       lOO.                .OO:
${c1}       .k00.              .00x
${c1}        .k00;            ;00O.
${c1}         .lO0Kc;,,,,,,;c0KOc.
${c1}            ;d00KKKKKK00d;
${c1}               .,KKKK,.
EOF
