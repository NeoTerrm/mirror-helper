#!/bin/bash

set -e

SELF_DIR="$(dirname $(readlink -f $0))"
source "$SELF_DIR/config.sh"

if [[ "$1" != "--no-gather" ]]; then
    for REPO_NAME in ${!REPOS[@]}; do
        REPO_SRC="${REPOS[$REPO_NAME]}"
        echo " * Building $REPO_NAME from $REPO_SRC"
        
        ./gather-packages.sh "$REPO_NAME" "$REPO_SRC"
    done
fi

./update-package-info.sh

