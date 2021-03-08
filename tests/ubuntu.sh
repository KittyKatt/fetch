#!/usr/bin/env bash
# shellcheck disable=SC2034
f=0
trap 'f=1' ERR

source ./lib/Linux/Ubuntu/ubuntu/ascii.sh

reset=$'\e[0m'
successOut () {
    success=$'\033[0m\033[32m'
    printf '>> %s\n' "${success}${1}${reset}"
}
errorOut () {
    error=$'\033[0m\033[1;31m'
    printf '%s\n' "${error}${1}${reset}"
}

n=0
IFS=$'\n'
while read -r line; do
    _output[${n}]="${line}"
    ((n++))
done <<< "$(bash fetch.sh --config sample.config.conf -v)"

if [[ ! ${_output[0]} =~ ^(.*)'Finding kernel...found as'(.*)'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+'-'[[:digit:]]+'-azure' ]]; then
    errorOut "!! Failed on kernel."
    errorOut "\tfailed line: ${_output[0]}"
    errorOut '\t%s\n' "\t\$(uname -srm): $(uname -srm)"
    f=1
else
    successOut "Kernel succeeded."
fi

if [[ ! ${_output[1]} =~ ^(.*)'Finding OS...found as'(.*)'Linux'(.*)'.' ]]; then
    errorOut "!! Failed on OS."
    f=1
else
    successOut "OS succeeded."
fi

if [[ ! ${_output[2]} =~ ^(.*)'Finding user info...found as'(.*)'runner@'[^[:space:]]+'.' ]]; then
    errorOut "!! Failed on user info."
    errorOut "\t\${USER}: ${USER}"
    errorOut "\t\${HOSTNAME}: ${HOSTNAME}"
    errorOut "\t\$(hostname): $(hostname)"
    f=1
else
    successOut "User info succeeded."
fi

# count number of verbosity lines
numlines=$(awk -F=$'\n' '/^:: Finding/ {print NF}' <<< "${_output[@]}")
printf '%s\n' "${numlines}"

#for (( i = 0; i <= n; i++)); do
#    printf '%s\n' "${i}"
#done