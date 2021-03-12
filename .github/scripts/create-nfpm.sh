#!/usr/bin/env bash
_name="${1}"
_maintainer="${2}"
_desc="${3}"
_version="${4}"

read -rd '' yaml <<EOF
name: ${_name}
arch: all
version: ${_version}
maintainer: ${_maintainer}
description: ${_desc}

contents:
  - src: lib
    dst: /usr/share/fetch/lib
  - src:
    dst: /usr/share/fetch/ascii
  - src: fetch.sh
    dst: /usr/local/bin/fetch
    file_info:
      mode: 0755
  - src: sample.config.yaml
    dst: /usr/share/fetch/config.yaml
    file_info:
      mode: 0666
    type: config
  - src: LICENSE
    dst: /usr/share/fetch/LICENSE

overrides:
  deb:
    depends:
      - bash (>= 4.0)
      - awk
  rpm:
    depends:
      - bash (>= 4.0)
      - awk
EOF

printf '%s\n' "${yaml}" > configuration.yaml