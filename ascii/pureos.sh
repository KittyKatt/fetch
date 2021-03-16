# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
# logo width: 44
if [ ! "${config_text[color]}" == "off" ]; then
	c1=$(getColor 'dark grey') # "Black"
fi
startline="1"
read -rd '' asciiLogo <<'EOF'
${c1}
${c1}  dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd
${c1}  dNm//////////////////////////////////mNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNd                                  dNd
${c1}  dNm//////////////////////////////////mNd
${c1}  dmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmd
${c1}
${c1}
EOF
