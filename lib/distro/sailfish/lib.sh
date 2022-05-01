# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154,SC2312
if [[ -f /etc/os-release ]]; then
  distro_codename="$(grep 'VERSION=' /etc/os-release | cut -d '(' -f2 | cut -d ')' -f1)"
  distro_release="$(awk -F'=' '/^VERSION=/ {print $2}' /etc/os-release)"
fi
