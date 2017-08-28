#!/bin/bash

debs="$1"

if [[ "$debs" == "" ]]; then
	echo "Usage: $0 <debs dir>"
	exit
fi

echo "Cleaning old debs in $debs"

function package_name() {
	local file="$1"
	dpkg-deb --info $file | grep Package: | cut -d':' -f2 | sed 's| ||g'
}

function package_version() {
	local file="$1"
	dpkg-deb --info $file | grep Version: | cut -d':' -f2 | sed 's| ||g'
}

function package_arch() {
	local file="$1"
	dpkg-deb --info $file | grep Architecture: | cut -d':' -f2 | sed 's| ||g'
}

declare -A aarch64_PKG
declare -A x86_64_PKG
declare -A arm_PKG
declare -A i686_PKG
declare -A all_PKG

for pkg_file in $debs/*.deb; do
	package_name="$(package_name $pkg_file)"
	package_arch="$(package_arch $pkg_file)"
	package_version="$(package_version $pkg_file)"
	
# echo "Checking for $package_name @ $package_arch - $package_version"
	declare -n T="${package_arch}_PKG"

	if [[ "${T[$package_name]}" == "" ]]; then
		T["$package_name"]="$pkg_file"
		continue

	else
		prev_file="${T["$package_name"]}"
		prev_version="$(package_version $prev_file)"

		./compare-version.sh "$package_version" "$prev_version" &>/dev/null
		retval=$?
		case $retval in
			0 ) # Package version is the same.
				;;
			2 ) # package_version < prev_version
				;;
			1 ) # package_version > prev_version
				T["$package_name"]="$pkg_file"
				echo "  Replacing $package_name @ $package_arch: $package_version, deleting old one: $prev_version ($prev_file)"	
				rm -f "$prev_file"
				;;
		esac
	fi
done


