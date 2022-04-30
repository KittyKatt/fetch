# shellcheck shell=bash
# shellcheck disable=SC2154
detect_shell() {
    # get configuration on whether full shell path should be displayed
    # shellcheck disable=SC2154
    case ${config_shell[path]} in
        on) shell_type="${SHELL}" ;;
        off | *) shell_type="${SHELL##*/}" ;;
    esac

    # if version_info is off, then return what we have now
    # shellcheck disable=SC2154
    [ "${config_shell[version]}" != "on" ] && my_shell="${shell_type}" && return

    # Possible Windows problem
    [ "${my_os}" == "Windows" ] && shell_name="${shell_type//\.exe/}"

    # get shell versions
    my_shell="${shell_name:=${shell_type}} "

    case ${shell_name:=${SHELL##*/}} in
        bash)
            # shellcheck disable=SC2016
            [ -n "${BASH_VERSION}" ] || BASH_VERSION=$("${SHELL}" -c 'printf %s "$BASH_VERSION"')
            my_shell+="${BASH_VERSION/-*/}"
            ;;
        sh | ash | dash | es) ;;
        *ksh)
            # shellcheck disable=SC2154,SC2016
            my_shell+=$("${SHELL}" -c 'printf %s "$KSH_VERSION"')
            my_shell=${my_shell/ * KSH/}
            my_shell=${my_shell/version/}
            ;;
        osh)
            # shellcheck disable=SC2016
            {
                if [[ -n ${OIL_VERSION} ]]; then
                    my_shell+=${OIL_VERSION}
                else
                    my_shell+=$("${SHELL}" -c 'printf %s "$OIL_VERSION"')
                fi
            }
            ;;
        tcsh)
            # shellcheck disable=SC2016
            my_shell+=$("${SHELL}" -c 'printf %s "$tcsh"')
            ;;
        yash)
            my_shell+=$("${SHELL}" --version 2>&1)
            my_shell=${my_shell/ ${shell_name}/}
            my_shell=${my_shell/ Yet another shell/}
            my_shell=${my_shell/Copyright*/}
            ;;
        fish)
            # shellcheck disable=SC2016
            [ -n "${FISH_VERSION}" ] || FISH_VERSION=$("${SHELL}" -c 'printf %s "$FISH_VERSION"')
            my_shell+="${FISH_VERSION}"
            ;;
        *)
            my_shell+=$("${SHELL}" --version 2>&1)
            my_shell=${my_shell/ ${shell_name}/}
            ;;
    esac

    # remove unwanted
    my_shell=${my_shell/, version/}
    my_shell=${my_shell/xonsh\//xonsh }
    my_shell=${my_shell/options*/}
    my_shell=${my_shell/\(*\)/}

    # TODO: check verbosity here instead of in function, save function call
    verboseOut "Finding current shell...found as '${my_shell}'."
}
