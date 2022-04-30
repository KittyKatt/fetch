# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
if [[ -f /etc/issue ]]; then
  if grep -q '^KDE neon' /etc/issue; then
    # shellcheck disable=SC2312
    distro_release="$(grep '^KDE neon' /etc/issue | cut -d ' ' -f3)"
  fi
fi
