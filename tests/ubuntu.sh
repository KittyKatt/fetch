#!/usr/bin/env bash
# shellcheck disable=SC2034
f=0
trap 'f=$((f+1))' ERR

success='\033[0m\033[32m'
error='\033[0m\033[1;31m'
reset='\e[0m'

n=0
IFS=$'\n'
while read -r line; do
    _output[${n}]="${line}"
    ((n++))
done <<< "$(bash fetch.sh --config sample.config.conf -v)"

if [[ ! ${_output[0]} =~ ^(.*)'Finding kernel...found as'(.*)'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+'-'[[:digit:]]+'-azure' ]]; then
    printf '%s\n' "${error}! Failed on kernel.${reset}"
    printf '\t%s\n' "${error}failed line: ${_output[0]}${reset}"
    printf '\t%s\n' "${error}\$(uname -srm): $(uname -srm)${reset}"
    _output[0]+="[FAILED]"
else
    printf '%s\n' "${success}Kernel succeeded.${reset}"
fi

if [[ ! ${_output[1]} =~ ^(.*)'Finding OS...found as'(.*)'Linux'(.*)'.' ]]; then
    printf '%s\n' "${error}! Failed on OS.${reset}"
    _output[1]+="[FAILED]"
else
    printf '%s\n' "${success}OS succeeded.${reset}"
fi

if [[ ! ${_output[2]} =~ ^(.*)'Finding user info...found as'(.*)'runner@'[^[:space:]]+'.' ]]; then
    printf '%s\n' "${error}! Failed on user info.${reset}"
    printf '\t%s\n' "${error}\${USER}: ${USER}${reset}"
    printf '\t%s\n' "${error}\${HOSTNAME}: ${HOSTNAME}${reset}"
    printf '\t%s\n' "${error}\$(hostname): $(hostname)${reset}"
    _output[2]+="[FAILED]"
else
    printf '%s\n' "${success}User info succeeded.${reset}"
fi

for (( i = 0; i <= n; i++)); do
    printf '%s\n' "${i}"
done