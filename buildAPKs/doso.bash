#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by S D Rausty; See LICENSE
# File `doso.bash` is under development
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 175 176 177 "${0##*/} doso.bash" 
printf "%s\\n" "File \`doso.bash\` is being developed."
declare CPUABI=""
CPUABI="$(getprop ro.product.cpu.abi)" 
declare -A AMKARR # associative array
# populate target architecture directory structure:
# PRSTARR=([arm64-v8a]=lib/arm64-v8a/libname.so [armeabi-v7a]=lib/armeabi-v7a/libname.so [x86]=lib/x86/libname.so [x86_64]=lib/x86_64/libname.so)
printf "%s\\n" "$CPUABI"
AMKFS=($(find "$JDR" -type f -name Android.mk -or -name CMakeLists.txt)) # Parameter Substitution
if [[ -z "${AMKFS[@]:-}" ]]
then
	:
else
	for FAMK in ${AMKFS[@]}
	do
		echo $FAMK 
	done
	for FAMK in ${AMKFS[@]}
	do 
		if [[ $(echo $FAMK) = 0 ]]
		then
			printf "%s\\n" "0 Android.mk files found."
		else
			printf "%s\\n" "Found $FAMK."
			cd  "${FAMK%/*}" 
			echo "Beginning cmake && make in $PWD"
			cmake . || printf "%s\\n" "Signal 42 gernerated in cmake ${0##/*} doso.bash"
			make || printf "%s\\n" "Signal 44 gernerated in make ${0##/*} doso.bash"
			cd  "${APP%/*}"
			echo "Change directory $PWD"
		fi
	done
fi
# doso.bash EOF
