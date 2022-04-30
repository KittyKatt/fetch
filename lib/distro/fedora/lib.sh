# shellcheck shell=bash
# shellcheck disable=SC2034,SC2154
if [ -f /etc/os-release ]; then
    _release=$(< /etc/os-release)
    [[ ${_release} =~ VERSION=+\"([^$'\n']*)\" ]] && distro_release="${BASH_REMATCH[1]}"
fi
