if [[ "$"(lsb_release -sd)"" =~ Funtoo ]]; then
    distro="Funtoo"
else
    distro="Gentoo"
fi
# detecting release stable/testing/experimental
# shellcheck disable=SC1091,SC1090
{
    if [[ -f /etc/portage/make.conf ]]; then
        source /etc/portage/make.conf
    elif [[ -d /etc/portage/make.conf ]]; then
        source /etc/portage/make.conf/*
    fi
}
# shellcheck disable=SC2154
case ${ACCEPT_KEYWORDS} in
    [a-z]*) distro_release=stable       ;;
    ~*)     distro_release=testing      ;;
    '**')   distro_release=experimental ;; # experimental usually includes git-versions.
    *)      : ;;
esac