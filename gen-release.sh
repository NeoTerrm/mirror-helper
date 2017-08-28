#!/bin/bash

export LC_TIME=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_COLLATE=en_US.UTF-8

cat <<EOF
Codename: stable
Version: 1
Architectures: all aarch64 arm x86_64
Description: Main repository
Suite: stable
Date: $(date -u "+%a, %d %b %Y %H:%m:%S UTC")
SHA256:
EOF

for i in `find main -name "Packages*"`; do echo " $(sha256sum $i | cut -d' ' -f1) $(ls -l $i | cut -d' ' -f5) $i";done

