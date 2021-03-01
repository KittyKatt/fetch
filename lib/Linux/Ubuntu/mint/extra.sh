if [[ "${distro_codename}" == "debian" ]]; then
    distro="LMDE"
    distro_codename="n/a"
    distro_release="n/a"
#adding support for LMDE 3	
elif [[ $(lsb_release -sd) =~ "LMDE" ]]; then
    distro="LMDE"	
fi