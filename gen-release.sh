#!/bin/bash
cat <<EOF
Codename: stable
Version: 1
Architectures: all aarch64
Description: Main repository
Suite: stable
Date: $(date -u "+%a, %d %b %Y %H:%m:%S UTC")
SHA256:
EOF

for i in `find main -name "Packages*"`; do echo " $(sha256sum $i | cut -d' ' -f1) $(ls -l $i | cut -d' ' -f5) $i";done

