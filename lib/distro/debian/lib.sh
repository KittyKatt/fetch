# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
if [[ -f /etc/siduction-version ]]; then
  my_distro="Siduction"
  distro_release="(Debian Sid)"
  distro_codename=
elif [[ -f /usr/bin/pveversion ]]; then
  my_distro="Proxmox VE"
  distro_codename=
  # shellcheck disable=SC2312
  distro_release="$(/usr/bin/pveversion | grep -oP 'pve-manager\/\K\d+\.\d+')"
elif [[ -f /etc/os-release ]]; then
  if grep -q -i 'Raspbian' /etc/os-release; then
    my_distro="Raspbian"
    distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
  elif grep -q -i 'BlankOn' /etc/os-release; then
    my_distro='BlankOn'
    distro_release=$(awk -F'=' '/^PRETTY_NAME=/ {print $2}' /etc/os-release)
  else
    my_distro="Debian"
  fi
fi
