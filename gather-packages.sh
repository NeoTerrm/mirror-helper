#!/bin/bash

set -e

if [[ "$#" != 2 ]]; then
    echo "Usage: $0 <repo-name> <repo-src>"
    exit 1
fi

repo="$1"
debs="$2"

if [[ "$repo" == "" || "$debs" == "" ]]; then
    echo "Usage: $0 <repo-name> <repo-src>"
    exit 1
fi

SELF_DIR="$(dirname $(readlink -f $0))"
source "$SELF_DIR/config.sh"

line_width="$(stty size | cut -d' ' -f2)"

function clear_line() {
    printf "\r%*c\r" "$line_width" '*'
}

function gather_thread() {
    local arch="$1"
    local i
    local dir
    local info_text
    local pkg_name
    local md5
    local target_md5
    local info_text
    local target
    
    for i in $debs/*.deb; do
        dir="dists/$repo/binary-$arch"
		mkdir -p "$dir"

		if $(echo $i | grep "_${arch}.deb" &>/dev/null) ; then
			target="$dir/$(basename $i)"
			pkg_name="$(basename $i)";
			pkg_name="${pkg_name%%_*}"

			if [[ -f "$target" ]]; then
				target_md5="$(md5sum $target | cut -d' ' -f1)"
				md5="$(md5sum $i | cut -d' ' -f1)"
				if [[ "$md5" == "$target_md5" ]]; then
					info_text="Skip"
				else
					info_text="Update"
					cp "$i" "$target"
				fi
			else
				info_text="New"
				cp "$i" "$target"
			fi
            
            clear_line
			printf "\r  %-8s\t%-8s\t%s" "$info_text" "$arch" "$pkg_name"
            if [[ "$info_text" == "New" || "$info_text" == "Update" ]]; then
                echo
            fi
		fi
    done
    echo
    echo " * Gather thread for $arch done"
}

for arch in ${GATHER_ARCH[@]}; do
    echo " * Gather thread for $arch started"
    gather_thread "$arch" &
done

PROC_NAME="$(ps $$ | grep $$ | cut -d' ' -f13)"
trap "echo ' * Killing'; pkill $PROC_NAME" INT
wait



