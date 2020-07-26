#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by SDRausty; See LICENSE
# File `doso.bash` is currently being developed
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
"$RDR"/scripts/bash/shlibs/trap.bash 146 147 148 "${0##*/} doso.bash"
. "$RDR/scripts/sh/shlibs/inst.sh"
_INST_ "cmake" "cmake" "doso.bash"
_INST_ "make" "make" "doso.bash"
CPUABI="$(getprop ro.product.cpu.abi)"
printf "\\e[1;38;5;113m%s\\n" "Searching for Android.mk and CMakeLists.txt files in ~/$(cut -d"/" -f7-99 <<< "$JDR")/;  Please be patient..."
AMKFS=("$(find "$JDR" -type f -name Android.mk -or -name CMakeLists.txt)")
_DOMAKES_() {
	for FAMK in "${AMKFS[@]}"
	do
		if [[ $FAMK = 0 ]] # no files found
		then
			printf "%s\\n" "No Android.mk and CMakeLists.txt files were found; Continuing..."
		else
			printf "%s\\n" "Found ~/$(cut -d"/" -f7-99 <<< "$FAMK")."
			mkdir -p "$JDR/bin/lib/$CPUABI"
			cp -r "${FAMK%/*}/*" "$JDR/bin/lib/$CPUABI"
			cd "$JDR/bin/lib/$CPUABI"
			printf "Beginning cmake in ~/%s/...\\n" "$(cut -d"/" -f7-99 <<< "$PWD")"
			cmake "${FAMK%/*}" || printf "%s\\n" "Signal 42 generated in cmake ${0##*/} doso.bash"
			printf "Beginning make in ~/%s/...\\n" "$(cut -d"/" -f7-99 <<< "$PWD")"
			make || printf "%s\\n" "Signal 44 generated in make ${0##*/} doso.bash"
			printf "Finished cmake && make in ~/%s/.\\e[0m\\n" "$(cut -d"/" -f7-99 <<< "$PWD")"
		fi
	done
}

if [[ -z "${AMKFS[@]:-}" ]] # is undefined
then # no files found
	printf "%s\\n" "No Android.mk and CMakeLists.txt files were found; Continuing..."
else # call cmake and make
	_DOMAKES_
fi
# doso.bash EOF
