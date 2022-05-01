# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154,SC2312
if [[ -f /etc/issue ]]; then
  if grep -q '^KDE neon' /etc/issue; then
    distro_release="$(grep '^KDE neon' /etc/issue | cut -d ' ' -f3)"
  fi
fi
