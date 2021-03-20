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

if [[ $(bash fetch --config sample.config.conf --lib . -v) ]]; then
    successOut 'Fetched current output:'
    bash fetch --config sample.config.conf --lib . -v
else
    errorOut 'fetch failed output:'
    bash fetch --config sample.config.conf --lib . -v
    exit 1
fi
