#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by SDRausty; See LICENSE
# File `doso.bash` assists in creating `.so` files.
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR/scripts/sh/shlibs/inst.sh"
_INST_ "cmake" "cmake" "${0##*/} doso.bash"
_INST_ "make" "make" "${0##*/} doso.bash"
_DMAKE_() {
	printf "%s\\n" "Beginning cmake and make in ~/$(cut -d"/" -f7-99 <<< "$PWD"):"
	cmake . && make || printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal 42 generated in cmake && make ${0##*/} doso.bash"
}
_DNINJA_() {
	_INST_ "ninja" "ninja" "${0##*/} doso.bash"
	export CMAKE_GENERATOR="Ninja"
	printf "%s\\n" "Beginning cmake and ninja in ~/$(cut -d"/" -f7-99 <<< "$PWD"):"
	cmake . && ninja || printf "\\e[1;48;5;167m%s\\e[0m\\n" "Signal 42 generated in cmake && ninja ${0##*/} doso.bash"
}
CPUABI="$(getprop ro.product.cpu.abi)"
printf "\\e[1;38;5;113m%s\\n" "Searching for CMakeLists.txt files in ~/$(cut -d"/" -f7-99 <<< "$JDR")/;  Please be patient..."
AMKFS=("$(find "$JDR" -type f -name CMakeLists.txt)")
_DOMAKES_() {
	for FAMK in ${AMKFS[@]}
	do
			printf "%s\\n" "Processing ~/$(cut -d"/" -f7-99 <<< "$FAMK")."
			UNUM="$(date +%s)"
			sleep 1
			mkdir -p "$JDR/bin/lib/$CPUABI/$UNUM"
			cp -ar "${FAMK%/*}"/* "$JDR/bin/lib/$CPUABI/$UNUM"
			cd "$JDR/bin/lib/$CPUABI/$UNUM"
			[[ $(head -n 1 "$RDR/.conf/DOSON") = 0 ]] && _DNINJA_ || _DMAKE_
			find . -type f -name "*.so" -exec mv {} "$JDR/bin/lib/$CPUABI" \; || printf "\\e[1;48;5;168m%s\\e[0m\\n" "Signal 46 generated in find -name *.so ${0##*/} doso.bash"
			printf "%s\\n" "Finished cmake and make in ~/$(cut -d"/" -f7-99 <<< "$PWD")/."
			cd "$JDR"
	done
}
if [[ -z "${AMKFS[@]:-}" ]] # is undefined
then # no files found
	printf "%s\\n" "No CMakeLists.txt files were found; Continuing..."
else # call cmake and make
	[[ "${#AMKFS[@]}" = 1 ]] && printf "%s\\n" "Found ${#AMKFS[@]} CMakeLists.txt file." || printf "%s\\n" "Found ${#AMKFS[@]} CMakeLists.txt files."
	_DOMAKES_
fi
# doso.bash EOF
