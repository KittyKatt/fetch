# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
if [ -f /etc/os-release ]; then
  if grep -q -i 'SUSE Linux Enterprise' /etc/os-release; then
    my_distro="SUSE Linux"
    distro_codename=
    distro_release=$(awk -F'=' '/^VERSION_ID=/ {print $2}' /etc/os-release | tr -d '"')
  fi
fi
if [ "${distro_codename}" == "Tumbleweed" ]; then
  distro_release=
fi
