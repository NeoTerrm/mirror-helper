#!/bin/bash

set -e

SELF_DIR="$(dirname $(readlink -f $0))"
source "$SELF_DIR/config.sh"

echo "* Generating index"
$SELF_DIR/gen-release.sh > Release
$SELF_DIR/gen-release.sh > InRelease

echo "* Signing"
gpg -abs --default-key $GPG_KEY -o Release.gpg Release

gpg --clearsign --default-key $GPG_KEY -o InRelease.gpg InRelease

echo "* Cleaning"
cat InRelease.gpg > InRelease
rm Release.gpg InRelease.gpg

