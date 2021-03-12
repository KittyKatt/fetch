# logo width: 37
# number of colors: 2
c1=$(getColor 'white') # White
c2=$(getColor 'light blue') # Light Blue
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}              __
${c1}          _=(SDGJT=_
${c1}        _GTDJHGGFCVS)
${c1}       ,GTDJGGDTDFBGX0
${c1}      JDJDIJHRORVFSBSVL${c2}-=+=,_
${c1}     IJFDUFHJNXIXCDXDSV,${c2}  "DEBL
${c1}    [LKDSDJTDU=OUSCSBFLD.${c2}   '?ZWX,
${c1}   ,LMDSDSWH'     `DCBOSI${c2}     DRDS],
${c1}   SDDFDFH'         !YEWD,${c2}   )HDROD
${c1}  !KMDOCG            &GSU|${c2}_GFHRGO'
${c1}  HKLSGP'${c2}           __${c1}TKM0${c2}GHRBV)'
${c1} JSNRVW'${c2}       __+MNAEC${c1}IOI,${c2}BN'
${c1} HELK['${c2}    __,=OFFXCBGHC${c1}FD)
${c1} ?KGHE ${c2}_-#DASDFLSV='${c1}    'EF
${c1} 'EHTI                    !H
${c1}  `0F'                    '!
${c1}
${c1}
EOF