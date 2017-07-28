#!/bin/bash

#rm -rf dists/stable/main/*
./gather-packages.sh ../neoterm-packages/debs
./update-package-info.sh

