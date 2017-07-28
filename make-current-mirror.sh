#!/bin/bash

#rm -rf dists/stable/main/*
./gather-packages.sh ../neoterm-packages/debs
./update.sh

#sudo tar jcvf /media/sf_Windows/mirror.tar.bz2 *


