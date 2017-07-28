#!/bin/bash

for i in dists/stable/main/*; do
	echo "Scan $i"
	dpkg-scanpackages $i > $i/Packages
	xz -9c $i/Packages > $i/Packages.xz
done

cd dists/stable
./gen-files.sh
cd ../..

find dists -type f -name "*.deb" > filelist.local
cat filelist.local > filelist

