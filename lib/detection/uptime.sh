# shellcheck shell=bash
# shellcheck disable=SC2154
detect_uptime() {
    # get seconds up since boot
    case ${my_os} in
        "Mac OS X" | "macOS" | BSD)
            boot=$(sysctl -n kern.boottime)
            [[ ${boot} =~ [0-9]+ ]] && boot=${BASH_REMATCH[0]}
            now=$(date +%s)
            _seconds=$((now - boot))
            ;;
        Linux | Windows | [G | g][N | n][U | u])
            if [ -f /proc/uptime ]; then
                _seconds=$(< /proc/uptime)
                _seconds=${_seconds//.*/}
            else
                boot=$(date -d"$(uptime -s)" +%s)
                now=$(date +%s)
                _seconds=$((now - boot))
            fi
            ;;
        Haiku)
            _seconds=$(($(system_time) / 1000000))
            ;;
        *) return ;;
    esac

    # math!
    _mins="$((_seconds / 60 % 60)) minutes"
    _hours="$((_seconds / 3600 % 24)) hours"
    _days="$((_seconds / 86400)) days"

    # get rid of plurals
    ((${_mins/ */} == 1)) && _mins=${_mins/s/}
    ((${_hours/ */} == 1)) && _hours=${_hours/s/}
    ((${_days/ */} == 1)) && _days=${_days/s/}

    # don't output if field is empty
    ((${_mins/ */} == 0)) && unset _mins
    ((${_hours/ */} == 0)) && unset _hours
    ((${_days/ */} == 0)) && unset _days

    # build the uptime line
    my_uptime=${_days:+${_days}, }${_hours:+${_hours}, }${_mins}
    my_uptime=${my_uptime%', '}
    my_uptime=${my_uptime:-${_seconds} seconds}

    # shorthand
    # shellcheck disable=SC2154
    case ${config_uptime[short]} in
        on)
            my_uptime=${my_uptime/ minutes/ mins}
            my_uptime=${my_uptime/ minute/ min}
            my_uptime=${my_uptime/ seconds/ secs}
            ;;
        tiny)
            my_uptime=${my_uptime/ days/d}
            my_uptime=${my_uptime/ day/d}
            my_uptime=${my_uptime/ hours/h}
            my_uptime=${my_uptime/ hour/h}
            my_uptime=${my_uptime/ minutes/m}
            my_uptime=${my_uptime/ minute/m}
            my_uptime=${my_uptime/ seconds/s}
            my_uptime=${my_uptime//,/}
            ;;
        off)
            :
            ;;
        auto | *)
            # shellcheck disable=SC2154
            if [ "${config_global[short]}" == 'on' ]; then
                my_uptime=${my_uptime/ minutes/ mins}
                my_uptime=${my_uptime/ minute/ min}
                my_uptime=${my_uptime/ seconds/ secs}
            fi
            ;;
    esac

    verboseOut "Finding current uptime...found as '${my_uptime}'."
}

detect_uptime
