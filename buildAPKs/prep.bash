#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 175 176 177 "${0##*/} prep.bash" 

_IAR_ () { 
	if [[ -z "${1:-}" ]] # no argument is given
	then
		if [[ -z "${WDIR:-}" ]]
		then
			if [[ ! -z "${JDR:-}" ]] && [[ ! -z "${SFX:-}" ]]
			then
				export WDIR="$JDR/$SFX"
			fi
			if [[ -z "${SFX:-}" ]]
			then
				export SFX=""
			fi
			if [[ -z "${WDIR:-}" ]]
			then
				export WDIR="$JDR/$SFX"
			fi
		fi
	else
		export WDIR="$1"
	fi
	_AFR_ || _SIGNAL_ "84" "_AFR_ _IAR_"
}

_AFR_ () { # finds and removes superfluous directories and files
	printf "\\e[?25h\\n\\e[1;48;5;102mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash: Processing elements in directory $WDIR: Please wait..."
	for NAME in "${DLIST[@]}"
	do
 		find "$WDIR" -type d -name "$NAME" -exec rm -rf {} \; 2>/dev/null ||:
	done
	for NAME in "${FLIST[@]}"
	do
		find "$WDIR" -type f -name "$NAME" -delete 2>/dev/null || : # _SIGNAL_ "87" "find \${FLIST[@]} _AFR_"
	done
	printf "\\e[?25h\\n\\e[1;48;5;101mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash $WDIR: DONE"
}

_SIGNAL_ () {
 	if [[ -z ${3:-} ]]
	then
		STRING="SIGNAL $1 generated in $2 ${0##*/} prep.bash!  Continuing...  "
		printf "\\e[2;7;38;5;210m%s\\e[0m" "$STRING" 
	else
		SG="$3"
		STRING="EXIT SIGNAL $1 generated in $2 ${0##*/} prep.bash!  Exiting with signal $SG..."
		printf "\\e[2;7;38;5;203m%s\\e[0m" "$STRING" 
		exit "$SG"
	fi
}

declare -a DLIST # declare array for all superfluous directories
declare -a FLIST # declare array for all superfluous files
DLIST=("bin" "gen" "obj" "out")
FLIST=("*-debug.key" "*.apk"  "*.aar" "lint.xml" "R.java")
# prep.bash EOF
