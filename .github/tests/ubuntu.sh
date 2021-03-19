#!/usr/bin/env bash
# TODO: test ASCII output
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


if [[ $(bash fetch --config sample.config.conf -v -C .) ]]; then
    successOut 'Fetched current output:'
    bash fetch --config sample.config.conf -C . -v
else
    errorOut 'fetch failed output:'
    bash fetch --config sample.config.conf -C . -v
    exit 1
fi

source ./ascii/ubuntu.sh

n=0
IFS=$'\n'
while read -r line; do
    _output[${n}]="${line}"
    ((n++))
done <<< "$(bash fetch --config sample.config.conf -v -C .)"

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
    errorOut "\tfailed line: ${_output[1]}"
    ((f++))
else
    successOut "OS succeeded."
fi

if [[ ! ${_output[2]} =~ ^(.*)'Finding user info...found as'(.*)'runner@'[^[:space:]]+'.' ]]; then
    errorOut "!! Failed on user info."
    errorOut "\tfailed line: ${_output[2]}"
    errorOut "\t\${USER}: ${USER}"
    errorOut "\t\${HOSTNAME}: ${HOSTNAME}"
    errorOut "\t\$(hostname): $(hostname)"
    ((f++))
else
    successOut "User info succeeded."
fi

if [[ ! ${_output[3]} =~ ^(.*)'Finding distribution...found as '\''Ubuntu '[[:digit:]]+'.'[[:digit:]]+[[:space:]](((LTS)[[:space:]])?)'('([[:alnum:]]|[[:space:]])+') x86_64'\''.' ]]; then
    errorOut "!! Failed on distribution."
    errorOut "\tfailed line: ${_output[3]}"
    [[ $(type -p lsb_release) || $(type -p lsb-release) ]] && errorOut "\t\$(lsb_release -sirc): $(lsb_release -sirc | tr '\r\n' ' ')"
    ((f++))
else
    successOut "Distribution succeeded."
fi

if [[ ! ${_output[4]} =~ ^(.*)'Finding current uptime...found as '\'([[:digit:]]|,|[[:space:]]|[[:alpha:]])+\''.' ]]; then
    errorOut "!! Failed on uptime."
    errorOut "\tfailed line: ${_output[4]}"
    errorOut "\t\$(uptime): $(uptime)"
    ((f++))
else
    successOut "Uptime succeeded."
fi

if [[ ! ${_output[5]} =~ ^(.*)'Finding current shell...found as '\''bash '[[:digit:]]'.'[[:digit:]]+'.'[[:digit:]]+\''.' ]]; then
    errorOut "!! Failed on shell."
    errorOut "\tfailed line: ${_output[5]}"
    errorOut "\t\${SHELL}: ${SHELL}"
    errorOut "\t\$(ps -e | grep \${PPID}): $(ps --no-headers ${PPID})"
    ((f++))
else
    successOut "Shell succeeded."
fi

if [[ ! ${_output[6]} =~ ^(.*)'Finding current package count...found as '\'[[:digit:]]+' (apt), '[[:digit:]]+' (snap)'\''.' ]]; then
    errorOut "!! Failed on package count."
    errorOut "\tfailed line: ${_output[6]}"
    if [[ $(type -p apt) ]]; then
        
        errorOut "\t\$(dpkg-query -W | wc -l): $(dpkg-query -W | wc -l)"
    else
        errorOut "\tapt doesn't exist"
    fi
    ((f++))
else
    successOut "Package count succeeded."
fi

if [[ ! ${_output[7]} =~ ^(.*)'Finding CPU...found as '\''Intel '([[:alnum:]|[[:space:]]|\-)+' ('[[:digit:]]+') @ '[[:digit:]]'.'[[:digit:]]+'GHz'\''.' ]]; then
    errorOut "!! Failed on CPU."
    errorOut "\tfailed line: ${_output[7]}"
    _cpufiletest="$(awk -F '\\s*: | @' \
        '/model name|Hardware|Processor|^cpu model|chip type|^cpu type/ {
        cpu=$2; if ($1 == "Hardware") exit } END { print cpu }' /proc/cpuinfo)"
    errorOut "\t\/proc/cpuinfo parsing: ${_cpufiletest}"
    ((f++))
else
    successOut "CPU succeeded."
fi

if [[ ! ${_output[8]} =~ ^(.*)'Finding memory usage...found as '\'([[:digit:]])+(MiB|KiB)' / '([[:digit:]])+(MiB|KiB)' ('([[:digit:]])+'%)'\''.' ]]; then
    errorOut "!! Failed on memory."
    errorOut "\tfailed line: ${_output[8]}"
    ((f++))
else
    successOut "Memory succeeded."
fi

if ((f == 0)); then
    exit 0
else
    errorOut "failures: ${f}"
    exit 1
fi
