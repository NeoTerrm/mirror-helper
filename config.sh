#!/bin/bash

declare -A REPOS

# REPOS[repo_name]=where_debs_are
REPOS["stable/main"]="../neoterm-packages/debs"

GATHER_ARCH=(aarch64 all x86_64 arm)

