#!/usr/bin/env bash
f=0
reset=$'\e[0m'
successOut () {
    success=$'\033[0m\033[32m'
    printf '%b\n' ">> ${success}${1}${reset}"
}
errorOut () {
    error=$'\033[0m\033[1;31m'
    printf '%b\n' "${error}${1}${reset}"
}


if [[ $(bash fetch.sh --config sample.config.conf -v) ]]; then
    successOut 'Fetched current output:'
    bash fetch.sh --config sample.config.conf -v
else
    errorOut 'fetch.sh failed output:'
    bash fetch.sh --config sample.config.conf -v
    exit 1
fi

source ./lib/Linux/Ubuntu/ubuntu/ascii.sh

n=0
IFS=$'\n'
while read -r line; do
    _output[${n}]="${line}"
    ((n++))
done <<< "$(bash fetch.sh --config sample.config.conf -v)"

if [[ ! ${_output[0]} =~ ^(.*)'Finding kernel...found as'(.*)'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+'-'[[:digit:]]+'-azure' ]]; then
    errorOut "!! Failed on kernel."
    errorOut "\tfailed line: ${_output[0]}"
    errorOut "\t\$(uname -srm): $(uname -srm)"
    ((f++))
else
    successOut "Kernel succeeded."
fi

if [[ ! ${_output[1]} =~ ^(.*)'Finding OS...found as'(.*)'Linux'(.*)'.' ]]; then
    errorOut "!! Failed on OS."
    ((f++))
else
    successOut "OS succeeded."
fi

if [[ ! ${_output[2]} =~ ^(.*)'Finding user info...found as'(.*)'runner@'[^[:space:]]+'.' ]]; then
    errorOut "!! Failed on user info."
    errorOut "\t\${USER}: ${USER}"
    errorOut "\t\${HOSTNAME}: ${HOSTNAME}"
    errorOut "\t\$(hostname): $(hostname)"
    ((f++))
else
    successOut "User info succeeded."
fi

if [[ ! ${_output[3]} =~ ^(.*)'Finding distribution...found as '\''Ubuntu '[[:digit:]]+'.'[[:digit:]]+[[:space:]](((LTS)[[:space:]])?)'('([[:alnum:]]|[[:space:]])+') x86_64'\''.' ]]; then
    errorOut "!! Failed on distribution."
    [[ $(type -p lsb_release) || $(type -p lsb-release) ]] && errorOut "\t\$(lsb_release -sirc): $(lsb_release -sirc | tr '\r\n' ' ')"
    ((f++))
else
    successOut "Distribution succeeded."
fi

if [[ ! ${_output[4]} =~ ^(.*)'Finding current uptime...found as '\'([[:digit:]]|,|[[:space:]]|[[:alpha:]])+\''.' ]]; then
    errorOut "!! Failed on uptime."
    errorOut "\t\$(uptime): $(uptime)"
    ((f++))
else
    successOut "Uptime succeeded."
fi

if [[ ! ${_output[5]} =~ ^(.*)'Finding current shell...found as '\''bash '[[:digit:]]'.'[[:digit:]]+'.'[[:digit:]]+\''.' ]]; then
    errorOut "!! Failed on shell."
    errorOut "\t\${SHELL}: ${SHELL}"
    errorOut "\t\$(ps -e | grep \${PPID}): $(ps --no-headers ${PPID})"
    ((f++))
else
    successOut "Shell succeeded."
fi

if ((f == 0)); then
    exit 0
else
    errorOut "failures: ${f}"
    exit 1
fi
