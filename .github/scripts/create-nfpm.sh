#!/usr/bin/env bash
_name="${1}"
_maintainer="${2}"
_desc="${3}"
_version="${4}"

read -rd '' yaml <<EOF
name: ${_name}
version: ${_version}
maintainer: ${_maintainer}
description: ${_desc}
depends:
  - bash (>=4.0)
  - awk

files:
  "/usr/local/bin/fetch":
    file: fetch.sh
    mode: "0755"
    user: "root"
  "/usr/share/fetch/ascii":
    file: ascii
  "/usr/share/fetch/lib":
    file: lib
  "/usr/share/fetch/config.yaml":
    file: sample.config.yaml
EOF

printf '%s\n' "${yaml}" > configuration.yaml