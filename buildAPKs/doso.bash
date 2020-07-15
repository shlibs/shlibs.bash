#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by S D Rausty; See LICENSE
# File `doso.bash` is under development
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 175 176 177 "${0##*/} doso.bash" 
printf "%s\\n" "File \`doso.bash\` is being developed."
_FUNZIP_()
{
	echo "zip -r -u "$PKGNAM.apk" "${APP%/*}/lib""
	zip -r -u "$PKGNAM.apk" "${APP%/*}/lib"
	echo "zip -r -u "$PKGNAM.apk" "${APP%/*}/lib": done"
}
declare CPUABI=""
CPUABI="$(getprop ro.product.cpu.abi)" 
declare -A AMKARR # associative array
# populate target architecture directory structure:
# PRSTARR=([arm64-v8a]=lib/arm64-v8a/libname.so [armeabi-v7a]=lib/armeabi-v7a/libname.so [x86]=lib/x86/libname.so [x86_64]=lib/x86_64/libname.so)
printf "%s\\n" "$CPUABI"
AMKFS=($(find "$JDR" -type f -name CMakeLists.txt)) 
# AMKFS=($(find "$JDR" -type f -name Android.mk -or -name CMakeLists.txt))
if [[ -z "${AMKFS[@]:-}" ]]
then
	echo "No CMakeLists.txt files found."
else
	for FAMK in ${AMKFS[@]}
	do
		echo 
		echo $FAMK 
		echo
	done
	for FAMK in ${AMKFS[@]}
	do 
		if [[ $(echo $FAMK) = 0 ]]
		then
			printf "%s\\n" "0 Android.mk files found."
		else
			printf "%s\\n" "Found $FAMK."
			cd  "${FAMK%/*}" 
			echo
			echo "Beginning cmake && make in $PWD"
			cmake . || printf "%s\\n" "Signal 42 gernerated in cmake ${0##/*} doso.bash"
			make || printf "%s\\n" "Signal 44 gernerated in make ${0##/*} doso.bash"
			echo
			SOARR=($(ls | egrep '\.o$|\.so$')) || printf "%s\\n" "Signal 46 gernerated in SOAR ${0##/*} doso.bash"
			if [[ -z "${SOARR[@]:-}" ]]
			then
				echo nothing to do
			else
				mkdir -p "${APP%/*}/lib/armeabi-v7a"
				for i in ${SOARR[@]}
				do
					printf "%s\\n" "Copying %s to %s/." "$i" "${APP%/*}/lib/armeabi-v7a" || printf "%s\\n" "Signal 48 gernerated in mv ${##*/}i ${0##/*} doso.bash" 
					cp "$i" "${APP%/*}/lib/armeabi-v7a" || printf "%s\\n" "Signal 48 gernerated in mv ${##*/}i ${0##/*} doso.bash" 
				done
			fi
			echo
			echo "Finishing cmake && make in $PWD"
			cd  "${APP%/*}"
			echo
			echo "Change directory to $PWD"
			echo
		fi
	done
fi
# doso.bash EOF
