# shellcheck shell=bash
# shellcheck disable=SC2154
detect_userinfo() {
  # shellcheck disable=SC2154
  if [ "${config_userinfo[display_user]}" == "on" ]; then
    my_user=${USER}
    if [ -z "${USER}" ]; then
      my_user=$(whoami)
    fi
    my_userinfo="${my_user}"
  fi

  # shellcheck disable=SC2154
  if [ "${config_userinfo[display_hostname]}" == "on" ]; then
    my_host="${HOSTNAME}"
    if [ "${my_distro}" == "Mac OS X" ] || [ "${my_distro}" == "macOS" ]; then
      my_host=${my_host/.local/}
    fi
    if [ -n "${my_userinfo}" ]; then
      my_userinfo="${my_userinfo}@${my_host}"
    else
      my_userinfo="${my_host}"
    fi
  fi

  verboseOut "Finding user info...found as '${my_userinfo}'."
}

detect_userinfo
