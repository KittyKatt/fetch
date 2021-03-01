if [ -f /etc/siduction-version ]; then
    distro="Siduction"
    distro_release="(Debian Sid)"
    distro_codename=
elif [ -f /usr/bin/pveversion ]; then
    distro="Proxmox VE"
    distro_codename=
    distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
elif [ -f /etc/os-release ]; then
    if grep -q -i 'Raspbian' /etc/os-release ; then
        distro="Raspbian"
        distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
    elif grep -q -i 'BlankOn' /etc/os-release ; then
        distro='BlankOn'
        distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
    else
        distro="Debian"
    fi
fi