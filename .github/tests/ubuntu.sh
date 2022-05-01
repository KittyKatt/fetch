#!/usr/bin/env bash
# TODO: test ASCII output
f=0
reset=$'\e[0m'
successOut()  {
  success=$'\033[0m\033[32m'
  printf '%b\n' ">> ${success}${1}${reset}"
}
errorOut()  {
  error=$'\033[0m\033[1;31m'
  printf '%b\n' "${error}${1}${reset}"
}

# shellcheck disable=SC2312
if [[ -n $(bash fetch --lib . --config sample.config.conf -v) ]]; then
  successOut 'Fetched current output:'
  bash fetch --lib . --config sample.config.conf -v
else
  errorOut 'fetch failed output:'
  bash fetch --lib . --config sample.config.conf -v
  exit 1
fi

# shellcheck disable=SC2016
ascii_expected='                          ./+o+-
                  yyyyy- -yyyyyy+
               ://+//////-yyyyyyo
           .++ .:/++++++/-.+sss/`
         .:++o:  /++++++++/:--:/-
        o:+o+:++.`..```.-/oo+++++/
       .:+o:+o/.          `+sssoo+/
  .++/+:+oo+o:`             /sssooo.
 /+++//+:`oo+o               /::--:.
 +/+o+++`o++o               ++////.
  .++.o+++oo+:`             /dddhhh.
       .+.o+oo:.          `oddhhhh+
        +.++o+o``-````.:ohdhhhhh+
         `:o+++ `ohhhhhhhhyo++os:
           .o:`.syhhhhhhh/.oo++o`
               /osyyyyyyo++ooo+++/
                   ````` +oo+++o:
                          `oo++.'
ascii_actual=$(bash fetch --lib . --config sample.config.conf -LN)
if [[ ${ascii_expected} != "${ascii_actual}" ]]; then
  errorOut "ASCII did not match expected output."
  errorOut "Actual output:"
  printf '%b\n' "${ascii_actual}"
  errorOut "What we expected:"
  printf '%b\n' "${ascii_expected}"
  ((f++))
else
  successOut "ASCII succeeded"
fi

# shellcheck disable=SC2312
if [[ ${BASH_VERSINFO[0]} -ge '4' ]]; then
  readarray _output < <(bash fetch --lib . --config sample.config.conf -TNv)
else
  n=0
  IFS=$'\n'
  while read -r line; do
    _output[${n}]="${line}"
    ((n++))
  done <<< "$(bash fetch --lib . --config sample.config.conf -TNv)"
fi

# shellcheck disable=SC2312
if [[ ${_output[*]} =~ ':: Finding kernel...found as '\'[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ 'Linux '[[:digit:]]+'.'[[:digit:]]+'.'[[:digit:]]+'-'[[:digit:]]+ ]]; then
    errorOut "!! Failed on kernel."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    errorOut "\t\$(uname -srm): $(uname -srm)"
    ((f++))
  else
      successOut "Kernel succeeded."
  fi
fi

if [[ ${_output[*]} =~ ':: Finding OS...found as '\'[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ 'Linux'(.*) ]]; then
    errorOut "!! Failed on OS."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    ((f++))
  else
    successOut "OS succeeded."
  fi
fi

# shellcheck disable=SC2312
if [[ ${_output[*]} =~ ':: Finding user info...found as '\'[[:print:]]+'@'[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ [^[:space:]]+'@'[^[:space:]]+ ]]; then
    errorOut "!! Failed on user info."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    errorOut "\t\${USER}: ${USER}"
    errorOut "\t\${HOSTNAME}: ${HOSTNAME}"
    errorOut "\t\$(hostname): $(hostname)"
    ((f++))
  else
      successOut "User info succeeded."
  fi
fi

# shellcheck disable=SC2312
if [[ ${_output[*]} =~ ':: Finding distribution...found as '\'[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ 'Ubuntu '[[:digit:]]+'.'[[:digit:]]+[[:space:]](((LTS)[[:space:]])?)'('([[:alnum:]]|[[:space:]])+') x86_64' ]]; then
    errorOut "!! Failed on distribution."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    [[ -n $(type -p lsb_release) || -n $(type -p lsb-release) ]] && errorOut "\t\$(lsb_release -sirc): $(lsb_release -sirc | tr '\r\n' ' ')"
    ((f++))
  else
    successOut "Distribution succeeded."
  fi
fi

# shellcheck disable=SC2312
if [[ ${_output[*]} =~ ':: Finding current uptime...found as '[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ ([[:digit:]]|,|[[:space:]]|[[:alpha:]])+ ]]; then
    errorOut "!! Failed on uptime."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    errorOut "\t\$(uptime): $(uptime)"
    ((f++))
  else
    successOut "Uptime succeeded."
  fi
fi

# shellcheck disable=SC2312,SC2248
if [[ ${_output[*]} =~ ':: Finding current shell...found as '[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ (bash|zsh|ksh|fish)' '[[:digit:]]'.'[[:digit:]]+'.'[[:digit:]]+ ]]; then
    errorOut "!! Failed on shell."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    errorOut "\t\${SHELL}: ${SHELL}"
    errorOut "\t\$(ps -e | grep \${PPID}): $(ps --no-headers ${PPID})"
    ((f++))
  else
      successOut "Shell succeeded."
  fi
fi

# shellcheck disable=SC2312
if [[ ${_output[*]} =~ ':: Finding current package count...found as '[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ ([[:digit:]]+[[:space:]][[:punct:]][[:alnum:]]+[[:punct:]]([,]?)([[:space:]]?))+ ]]; then
    errorOut "!! Failed on package count."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    if [[ -n $(type -p apt) ]]; then
      errorOut "\t\$(dpkg-query -W | wc -l): $(dpkg-query -W | wc -l)"
    else
      errorOut "\tapt doesn't exist"
    fi
    ((f++))
  else
    successOut "Package count succeeded."
  fi
fi

if [[ ${_output[*]} =~ ':: Finding CPU...found as '[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ (AMD|Intel)[[:space:]][[:alnum:][:space:]]+[[:punct:]][[:digit:]]+[[:punct:]][[:space:]]+(@)[[:space:]][[:digit:][:punct:]]+'GHz' ]]; then
    errorOut "!! Failed on CPU."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    _cpufiletest="$(awk -F '\\s*: | @' \
      '/model name|Hardware|Processor|^cpu model|chip type|^cpu type/ {
      cpu=$2; if ($1 == "Hardware") exit } END { print cpu }' /proc/cpuinfo)"
    errorOut "\t\/proc/cpuinfo parsing: ${_cpufiletest}"
    ((f++))
  else
    successOut "CPU succeeded."
  fi
fi

if [[ ${_output[*]} =~ ':: Finding memory usage...found as '[[:print:]]+\''.' ]]; then
  if [[ ! ${BASH_REMATCH[0]} =~ ([[:digit:]])+(MiB|KiB)' / '([[:digit:]])+(MiB|KiB)' ('([[:digit:]])+'%)' ]]; then
    errorOut "!! Failed on memory."
    errorOut "\tfailed line: ${BASH_REMATCH[0]}"
    ((f++))
  else
    successOut "Memory succeeded."
  fi
fi

printf '\n'
successOut "Execution time: "
# shellcheck disable=SC2312
time bash fetch -c sample.config.conf -l . 2> /dev/null 1>&2

if ((f == 0)); then
  exit 0
else
  errorOut "failures: ${f}"
  exit 1
fi
