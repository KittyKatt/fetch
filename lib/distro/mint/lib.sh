# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
if [ "${distro_codename}" == "debian" ]; then
    my_distro="LMDE"
    distro_codename="n/a"
    distro_release="n/a"
#adding support for LMDE 3
elif [[ $(lsb_release -sd) =~ "LMDE" ]]; then
    my_distro="LMDE"
fi
