#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
# This script benchmarks attempted builds and deposited APKs.
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 169 170 171 "${0##*/} bnchn.bash"

if [[ "$1" = "bch.st" ]]
then
	ST="$(date +%s)"
elif [[ "$1" = "bch.gt" ]]
then
	ET="$(date +%s)"
	printf "\\nBuild time: %s seconds\\n\\n" "$(( $ET-$ST ))"
fi

# bnchn.bash OEF
