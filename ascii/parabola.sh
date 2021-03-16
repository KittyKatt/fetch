# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 33
c1=$(getColor 'purple') # Purple
startline="0"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}                          _,,     _
${c1}                   _,   ,##'    ,##;
${c1}             _, ,##'  ,##'    ,#####;
${c1}         _,;#',##'  ,##'    ,#######'
${c1}     _,#**^'         `    ,#########
${c1} .-^`                    `#########
${c1}                          ########
${c1}                          ;######
${c1}                          ;####*
${c1}                          ####'
${c1}                         ;###
${c1}                        ,##'
${c1}                        ##
${c1}                       #'
${c1}                      /
${c1}                     '
${c1}
EOF