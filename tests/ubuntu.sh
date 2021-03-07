#!/usr/bin/env bash
n=0
IFS=$'\n'
while read -r line; do
    _output[${n}]="${line}"
    ((n++))
done <<< "$(bash fetch.sh --config sample.config.conf -v)"

if [[ ! ${_output[0]} =~ ^(.*)'Finding kernel...found as'(.*)'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+'-'[[:digit:]]+'-azure' ]]; then
    echo "Failed on kernel."
    exit 1
else
    echo "Kernel succeeded."
fi

if [[ ! ${_output[1]} =~ ^(.*)'Finding OS...found as'(.*)'Linux'(.*)'.' ]]; then
    echo "Failed on OS."
    exit 1
else
    echo "OS succeeded."
fi

if [[ ! ${_output[2]} =~ ^(.*)'Finding user info...found as'(.*)'runner@'[^[:space:]]+'.' ]]; then
    echo "Failed on user info."
    exit 1
else
    echo "User info succeeded."
fi