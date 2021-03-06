if [ -f /etc/os-release ]; then
    source /etc/os-release
    distro_release="${VERSION%%+([[:space:]])}"
fi