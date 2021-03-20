# shellcheck shell=bash
# shellcheck disable=SC2154
fetchConfig() {
    if [ -f "${1}" ]; then
        while read -r line; do
            if [[ ${line} =~ ^\[[[:alnum:]]+\] ]]; then
                arrname="config_${line//[^[:alnum:]]/}"
                declare -gA "${arrname}"
            elif [[ ${line} =~ ^([_[:alpha:]][_[:alnum:]]*)"="(.*) ]]; then
                # shellcheck disable=SC2086
                {
                    _arr=${arrname}[${BASH_REMATCH[1]}]
                    [ -z ${!_arr} ] && declare -g ${arrname}[${BASH_REMATCH[1]}]="${BASH_REMATCH[2]//\"/}"
                    unset _arr
                }
            fi
        done < "${1}"
    else
        errorOut "No configuration file specified"
    fi
}
