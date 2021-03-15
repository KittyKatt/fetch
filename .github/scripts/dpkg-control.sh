#!/usr/bin/env bash

read -rd '' control <<EOF
Package: fetch
Priority: optional
Maintainer: "Brett Bohnenkamper" <kittykatt@kittykatt.co>
Version: ${1}
Section: utils
Architecture: all
Depends: bash (<=4.0), awk, procps, pciutils
Description: fetch is a BASH screenshot, system, and configuration information tool
Homepage: https://github.com/KittyKatt/fetch
EOF

mkdir debian
printf '%s\n' "${control}" > debian/control