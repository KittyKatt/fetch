#!/usr/bin/env bash

reset=$'\e[0m'
successOut () {
    success=$'\033[0m\033[32m'
    printf '%b\n' ">> ${success}${1}${reset}"
}
errorOut () {
    error=$'\033[0m\033[1;31m'
    printf '%b\n' "${error}${1}${reset}"
}

if [[ $(type -p dos2unix) ]]; then 
    $(which dos2unix) fetch.sh
    $(which dos2unix) lib/Windows/ascii.sh
else
    cat fetch.sh | sed 's/\r$//' | od -c > fetch2.sh
    mv fetch2.sh fetch.sh
    cat lib/Windows/ascii.sh | sed 's/\r$//' | od -c > lib/Windows/ascii2.sh
    mv lib/Windows/ascii2.sh lib/Windows/ascii.sh
fi

if [[ $(bash fetch.sh --config sample.config.conf -v) ]]; then
    successOut 'Fetched current output:'
    bash fetch.sh --config sample.config.conf -v
else
    errorOut 'fetch.sh failed output:'
    bash fetch.sh --config sample.config.conf -v
    exit 1
fi