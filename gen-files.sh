#!/bin/bash


./gen-release.sh > Release
./gen-inrelease.sh > InRelease

gpg -abs --default-key 51B87341B8090074C992D1342F1D76ABEEFACD36 -o Release.gpg Release 

gpg --clearsign --default-key 51B87341B8090074C992D1342F1D76ABEEFACD36 -o InRelease.gpg InRelease

cat InRelease.gpg > InRelease
rm Release.gpg InRelease.gpg

