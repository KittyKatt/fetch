# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154

# logo width: 46
# number of colors: 3
c1=$(getColor 'dark grey')  # Black
c2=$(getColor 'light blue') # Blue
c3=$(getColor 'light red')  # Beige
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}  ,
${c1}  OXo.
${c1}  NXdX0:    .cok0KXNNXXK0ko:.
${c1}  KX  '0XdKMMK;.xMMMk, .0MMMMMXx;  ...
${c1}  'NO..xWkMMx   kMMM    cMMMMMX,NMWOxOXd.
${c1}    cNMk  NK    .oXM.   OMMMMO. 0MMNo  kW.
${c1}    lMc   o:       .,   .oKNk;   ;NMMWlxW'
${c1}   ;Mc    ..   .,,'    .0M${c2}g;${c1}WMN'dWMMMMMMO
${c1}   XX        ,WMMMMW.  cM${c2}cfli${c1}WMKlo.   .kMk
${c1}  .Mo        .WM${c2}GD${c1}MW.   XM${c2}WO0${c1}MMk        oMl
${c1}  ,M:         ,XMMWx::,''oOK0x;          NM.
${c1}  'Ml      ,kNKOxxxxxkkO0XXKOd:.         oMk
${c1}   NK    .0Nxc${c3}:::::::::::::::${c1}fkKNk,      .MW
${c1}   ,Mo  .NXc${c3}::${c1}qXWXb${c3}::::::::::${c1}oo${c3}::${c1}lNK.    .MW
${c1}    ;Wo oMd${c3}:::${c1}oNMNP${c3}::::::::${c1}oWMMMx${c3}:${c1}c0M;   lMO
${c1}     'NO;W0c${c3}:::::::::::::::${c1}dMMMMO${c3}::${c1}lMk  .WM'
${c1}       xWONXdc${c3}::::::::::::::${c1}oOOo${c3}::${c1}lXN. ,WMd
${c1}        'KWWNXXK0Okxxo,${c3}:::::::${c1},lkKNo  xMMO
${c1}          :XMNxl,';:lodxkOO000Oxc. .oWMMo
${c1}            'dXMMXkl;,.        .,o0MMNo'
${c1}               ':d0XWMMMMWNNNNMMMNOl'
${c1}                     ':okKXWNKkl'
EOF