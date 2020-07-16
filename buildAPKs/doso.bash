#!/usr/bin/env bash
# Copyright 2020 (c) all rights reserved by S D Rausty; See LICENSE
# File `doso.bash` is under development
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
"$RDR"/scripts/bash/shlibs/trap.bash 146 147 148 "${0##*/} doso.bash"
printf "%s\\n" "File \`doso.bash\` is being developed."
declare COMMANDR
declare COMMANDIF
declare CPUABI=""
declare STRING1
declare STRING2
STRING1="COMMAND \`au\` enables rollback, available at https://wae.github.io/au/ IS NOT FOUND: Continuing... "
STRING2="Cannot update ~/${RDR##*/} prerequisite: Continuing..."
PKGS=(make cmake zip)
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

_FUNZIP_() {
	cd  "$JDR/bin"
	printf "Running zip -r -u %s.apk lib...\\n" "$PKGNAM" 
	zip -r -u "$PKGNAM.apk" "lib" 
}
CPUABI="$(getprop ro.product.cpu.abi)" 
printf "%s\\n" "Detected $CPUABI architecture. Searching for Android.mk and CMakeLists.txt files in ~/$(cut -d"/" -f7-99 <<< $JDR)/;  Please be patient..."
AMKFS=($(find "$JDR" -type f -name Android.mk -or -name CMakeLists.txt))
if [[ -z "${AMKFS[@]:-}" ]]
then
	printf "%s\\n" "No Android.mk and CMakeLists.txt files were found; Continuing..."
else
	for FAMK in ${AMKFS[@]}
	do 
		if [[ $FAMK = 0 ]]
		then
			printf "%s\\n" "Zero (0) Android.mk and CMakeLists.txt files found."
		else
			printf "%s\\n" "Found ~/$(cut -d"/" -f7-99 <<< $FAMK)."
			cd  "${FAMK%/*}" 
			printf "Beginning cmake in ~/%s/...\\n\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			cmake . || printf "%s\\n" "Signal 42 gernerated in cmake ${0##*/} doso.bash"
			printf "Beginning make in ~/%s/...\\n\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			make || printf "%s\\n" "Signal 44 gernerated in make ${0##*/} doso.bash"
			printf "Searching for *.so files in ~/%s/...\\n\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			SOARR=($(ls | egrep '\.o$|\.so$')) || printf "%s\\n" "Signal 46 gernerated in SOAR ${0##*/} doso.bash"
			if [[ -z "${SOARR[@]:-}" ]]
			then
				printf "%s\\n\\n" "Zero (-1) *.o and *.so files were found;  There is nothing to do."
			else
				mkdir -p "$JDR/bin/lib/armeabi-v7a"
				for i in ${SOARR[@]}
				do
					printf "\\nCopying %s to ~/%s/lib/armeabi-v7a/.\\n\\n" "$i" "$(cut -d"/" -f7-99 <<< "$JDR/bin/lib/armeabi-v7a")"
					cp "$i"  "$JDR/bin/lib/$CPUABI/" || printf "%s\\n" "Signal 48 gernerated in mv ${i##*/} ${0##/*} doso.bash" 
				done
			fi
			printf "Finishing cmake && make in ~/%s/.\\n\\n" "$(cut -d"/" -f7-99 <<< $PWD)"
			cd  "$JDR"
			_FUNZIP_ ||:
		fi
	done
fi
# doso.bash EOF
