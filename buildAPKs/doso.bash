#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by S D Rausty; See LICENSE
# File `doso.bash` is under development
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
"$RDR"/scripts/bash/shlibs/trap.bash 146 147 148 "${0##*/} doso.bash"
declare COMMANDR
declare COMMANDIF
declare CPUABI=""
declare STRING1
declare STRING2
STRING1="COMMAND \`au\` enables rollback, available at https://wae.github.io/au/ IS NOT FOUND: Continuing... "
STRING2="Cannot update ~/${RDR##*/} prerequisite: Continuing..."
PKGS=(make cmake)
COMMANDR="$(command -v au)" || (printf "%s\\n\\n" "$STRING1") 
COMMANDIF="${COMMANDR##*/}"
_INPKGS_() {
	if [[ "$COMMANDIF" = au ]] 
	then 
		au "${PKGS[@]}" || printf "\\e[1;38;5;117m%s\\e[0m\\n" "$STRING2"
	else
		apt install "${PKGS[@]}" || printf "\\e[1;37;5;116m%s\\e[0m\\n" "$STRING2"
	fi
}
for PKG in "${PKGS[@]}"
do
	COMMANDP="$(command -v "$PKG")" || printf "Command %s not found: Continuing...\\n" "$PKG" # test if command exists
	COMMANDPF="${COMMANDP##*/}"
	if [[ "$COMMANDPF" != "$PKG" ]] 
	then 
		printf "\\e[1;38;5;115m%s\\e[0m\\n" "Beginning buildAPKs \`doso.bash\` setup:"
		_INPKGS_
	fi
done

CPUABI="$(getprop ro.product.cpu.abi)" 
printf "\\e[1;38;5;113m%s\\n" "Searching for Android.mk and CMakeLists.txt files in ~/$(cut -d"/" -f7-99 <<< $JDR)/;  Please be patient..."
AMKFS=($(find "$JDR" -type f -name Android.mk -or -name CMakeLists.txt))
if [[ -z "${AMKFS[@]:-}" ]]
then
	printf "%s\\n" "No Android.mk and CMakeLists.txt files were found; Continuing..."
else
	for FAMK in ${AMKFS[@]}
	do 
		if [[ $FAMK = 0 ]]
		then
			printf "%s\\n" "No Android.mk and CMakeLists.txt files were found; Continuing..."
		else
			printf "%s\\n" "Found ~/$(cut -d"/" -f7-99 <<< $FAMK)."
			cd  "${FAMK%/*}" 
			printf "Beginning cmake in ~/%s/...\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			cmake . || printf "%s\\n" "Signal 42 generated in cmake ${0##*/} doso.bash"
			printf "Beginning make in ~/%s/...\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			make || printf "%s\\n" "Signal 44 generated in make ${0##*/} doso.bash"
			printf "Searching for *.so files in ~/%s/...\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			SOARR=($(ls | egrep '\.so$')) || printf "%s\\n" "Signal 46 generated in SOAR ${0##*/} doso.bash"
			if [[ -z "${SOARR[@]:-}" ]]
			then
				printf "%s\\n" "No *.so files were found;  There is nothing to do."
			else
				mkdir -p "$JDR/bin/lib/armeabi-v7a"
				for SOFILE in ${SOARR[@]}
				do
					printf "Copying %s to ~/%s/lib/$CPUABI/...\\n" "$SOFILE" "$(cut -d"/" -f7-99 <<< "$JDR/bin/lib/$CPUABI")"
					cp "$SOFILE"  "$JDR/bin/lib/$CPUABI/" || printf "%s\\n" "Signal 48 generated in mv ${i##*/} ${0##/*} doso.bash" 
				done
			fi
			printf "Finished cmake && make in ~/%s/.\\e[0m\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
		fi
	done
fi
# doso.bash EOF
