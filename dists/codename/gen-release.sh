#!/bin/bash

set -e

SELF_DIR="$(dirname $(readlink -f $0))"
source "$SELF_DIR/config.sh"

cat <<EOF
Codename: $CODE_NAME
Version: $VERSION
Architectures: ${ARCH[@]}
Description: $DESC
Suite: $SUITE
Date: $(date -u "+%a, %d %b %Y %H:%m:%S UTC")
SHA256:
EOF

for channel in ${CHANNELS[@]}; do
    for i in `find $channel -name "Packages*"`; do 
        echo " $(sha256sum $i | cut -d' ' -f1) $(ls -l $i | cut -d' ' -f5) $i"
    done
done

