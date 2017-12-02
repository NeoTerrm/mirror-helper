#!/bin/bash

set -e

SELF_DIR="$(dirname $(readlink -f $0))"
source "$SELF_DIR/config.sh"

function update_thread() {
    local repo_name_and_folder="$1"
    local channel_path="dists/$repo_name_and_folder"
    local i
    
	echo " * Scanning $channel_path"
	dpkg-scanpackages -m $channel_path > $channel_path/Packages
	xz -9c $channel_path/Packages > $channel_path/Packages.xz
	
    echo " * Update thread for $repo_name_and_folder done"
}

declare -A CODE_NAMES

for REPO_NAME in ${!REPOS[@]}; do
    code_name="$(dirname $REPO_NAME)"
    CODE_NAMES[$code_name]="1"
    
    for folder in `ls dists/$REPO_NAME`; do
        if [[ -d "dists/$REPO_NAME/$folder" ]]; then
            echo " * Update thread for $REPO_NAME/$folder started"
            update_thread "$REPO_NAME/$folder" &
        fi
    done
done

PROC_NAME="$(ps $$ | grep $$ | cut -d' ' -f13)"
trap "echo ' * Killing'; pkill $PROC_NAME" INT
wait

for CODE_NAME in ${!CODE_NAMES[@]}; do
    echo " * Building code name $CODE_NAME"
    (cd dists/stable && ./gen-files.sh)
done

find dists -type f -name "*.deb" > filelist.local
cat filelist.local > filelist

