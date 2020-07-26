#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by SDRausty; See LICENSE
# File `doso.bash` is currently being developed
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
"$RDR"/scripts/bash/shlibs/trap.bash 146 147 148 "${0##*/} doso.bash"
. "$RDR/scripts/sh/shlibs/inst.sh"
_INST_ "cmake" "cmake" "${0##*/} doso.bash"
_INST_ "make" "make" "${0##*/} doso.bash"
CPUABI="$(getprop ro.product.cpu.abi)"
printf "\\e[1;38;5;113m%s\\n" "Searching for Android.mk and CMakeLists.txt files in ~/$(cut -d"/" -f7-99 <<< "$JDR")/;  Please be patient..."
AMKFS=("$(find "$JDR" -type f -name Android.mk -or -name CMakeLists.txt)")
_DOMAKES_() {
	if [[ "${#AMKFS[@]}" = 0 ]] # zero files found
	then
		printf "%s\\n" "Zero Android.mk and CMakeLists.txt files were found; Continuing..."
	else
		for FAMK in "${AMKFS[@]}"
		do
				printf "%s\\n" "Found ~/$(cut -d"/" -f7-99 <<< "$FAMK")."
				mkdir -p "$JDR/bin/lib/$CPUABI"
				cp -r "${FAMK%/*}/*" "$JDR/bin/lib/$CPUABI"
				cd "$JDR/bin/lib/$CPUABI"
				printf "%s\\n" "Beginning cmake in ~/$(cut -d"/" -f7-99 <<< "$PWD")/..."
				cmake "${FAMK%/*}" || printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal 42 generated in cmake ${0##*/} doso.bash"
				printf "%s\\n" "Beginning make in ~/$(cut -d"/" -f7-99 <<< "$PWD")/..."
				make || printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal 44 generated in make ${0##*/} doso.bash"
				printf "%s\\n" "Finished cmake && make in ~/$(cut -d"/" -f7-99 <<< "$PWD")/."
		done
	fi
}
if [[ -z "${AMKFS[@]:-}" ]] # is undefined
then # no files found
	printf "%s\\n" "No Android.mk and CMakeLists.txt files were found; Continuing..."
else # call cmake and make
	_DOMAKES_
fi
# doso.bash EOF
