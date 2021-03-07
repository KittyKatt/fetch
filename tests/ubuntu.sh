IFS=$'\n' read -r -a _output <<< "$(bash fetch.sh --config sample.config.conf -v)"

[[ ! ${_output[0]} =~ ^(.*)'Finding kernel...found as'(.*)'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+  ]] && echo "Failed on kernel."; exit 1