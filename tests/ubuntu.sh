#!/usr/bin/env bash
n=0
IFS=$'\n'
while read -r line; do
    _output[${n}]="${line}"
    ((n++))
done <<< "$(bash fetch.sh --config sample.config.conf -v)"

if [[ ! ${_output[0]} =~ ^(.*)'Finding kernel...found as'(.*)'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+'-'[[:digit:]]+'-azure' ]]; then
    echo "! Failed on kernel."
    echo "  failed line: ${_output[0]}"
    echo "  \$(uname -srm): $(uname -srm)"
    _output[0]+="[FAILED]"
else
    echo "Kernel succeeded."
fi

if [[ ! ${_output[1]} =~ ^(.*)'Finding OS...found as'(.*)'Linux'(.*)'.' ]]; then
    echo "! Failed on OS."
    _output[1]+="[FAILED]"
else
    echo "> OS succeeded."
fi

if [[ ! ${_output[2]} =~ ^(.*)'Finding user info...found as'(.*)'runner@'[^[:space:]]+'.' ]]; then
    echo "! Failed on user info."
    echo "  \${USER}: ${USER}"
    echo "  \${HOSTNAME}: ${HOSTNAME}"
    echo "  \$(hostname): $(hostname)"
    _output[2]+="[FAILED]"
else
    echo "User info succeeded."
fi

[[ ${_output[*]} =~ \[FAILED\] ]] && echo "[ TESTS FAILED ]"; exit 1