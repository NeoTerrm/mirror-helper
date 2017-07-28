#!/bin/bash

debs="$1"

if [[ "$debs" == "" ]]; then
	echo "Usage: $0 <debs dir>"
	exit
fi

echo "Cleaning old debs in $debs"

function package_id() {
	local text="$(basename $1)"
	echo "${text%.*}"
}

function package_name() {
	local id="$1"
	echo "$id" | cut -d'_' -f1
}

function package_version() {
	local id="$1"
	echo "$id" | cut -d'_' -f2
}

function package_arch() {
	local id="$1"
	echo "$id" | cut -d'_' -f3
}

declare -A aarch64_PKG
declare -A x86_64_PKG
declare -A arm_PKG
declare -A i686_PKG

for pkg_file in $debs/*.deb; do
	id="$(package_id $pkg_file)"
	package_name="$(package_name $id)"
	package_arch="$(package_arch $id)"
	package_version="$(package_version $id)"
	
	declare -n T="${package_arch}_PKG"

	if [[ "${T[$package_name]}" == "" ]]; then
		T[$package_name]="$id"
		continue

	else
		prev_id="${T[$package_name]}"
		prev_version="$(package_version $prev_id)"

		./compare-version.sh "$package_version" "$prev_version" &>/dev/null
		case $? in
			0 ) # Package version is the same.
				;;
			2 ) # package_version < prev_version
				;;
			1 ) # package_version > prev_version
				T[$package_name]="$id"
				old_package_file="$debs/$prev_id.deb"
				echo "  Replacing $package_name@$package_arch: $package_version, deleting old: $prev_version"	
				rm $old_package_file
				;;
		esac
	fi
done


