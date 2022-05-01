# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 41
# number of colors: 1
if [[ ${config_text[color]} != "off" ]]; then
  c1=$(getColor '25') # Blue (25/#005faf)
fi
startline="3"
read -rd '' asciiLogo << 'EOF'
${c1}            ROSAROSAROSAROSAR
${c1}         ROSA               AROS
${c1}       ROS   SAROSAROSAROSAR   AROS
${c1}     RO   ROSAROSAROSAROSAROSAR   RO
${c1}   ARO  AROSAROSAROSARO      AROS  ROS
${c1}  ARO  ROSAROS         OSAR   ROSA  ROS
${c1}  RO  AROSA   ROSAROSAROSA    ROSAR  RO
${c1} RO  ROSAR  ROSAROSAROSAR  R  ROSARO  RO
${c1} RO  ROSA  AROSAROSAROSA  AR  ROSARO  AR
${c1} RO AROS  ROSAROSAROSA   ROS  AROSARO AR
${c1} RO AROS  ROSAROSARO   ROSARO  ROSARO AR
${c1} RO  ROS  AROSAROS   ROSAROSA AROSAR  AR
${c1} RO  ROSA  ROS     ROSAROSAR  ROSARO  RO
${c1}  RO  ROS     AROSAROSAROSA  ROSARO  AR
${c1}  ARO  ROSA   ROSAROSAROS   AROSAR  ARO
${c1}   ARO  OROSA      R      ROSAROS  ROS
${c1}     RO   AROSAROS   AROSAROSAR   RO
${c1}      AROS   AROSAROSAROSARO   AROS
${c1}         ROSA               SARO
${c1}            ROSAROSAROSAROSAR
EOF
