#!/usr/bin/env bash
# Copyright 2019-2021 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_IAR_ () {
	if [[ -z "${1:-}" ]] # no argument is given
	then
		if [[ -z "${WDIR:-}" ]]
		then
			if [[ -n "${JDR:-}" ]] && [[ -n "${SFX:-}" ]]
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
 		find "$WDIR" -type d -name "$NAME" -exec rm -rf {} \; 2>/dev/null
	done
	for NAME in "${FLIST[@]}"
	do
		(find "$WDIR" -type f -name "$NAME" -delete 2>/dev/null && ([ -f "$JDR/sha512.sum" ] && grep "$NAME" "$JDR/sha512.sum" 1>/dev/null && sed -i "/$NAME/d" "$JDR/sha512.sum" ))
	done
	[ ! -f "$RDR/var/tmp/$JID.sha512.0" ] && [ -f "$JDR/sha512.sum" ] && { CWDIRPWD="$PWD" && cd "$JDR" && printf "\\e[1;2m%s" "Running 'sha512sum --quiet -c sha512.sum' in directory '$PWD': $(sha512sum --quiet -c sha512.sum)" && cd "$CWDIRPWD" && touch "$RDR/var/tmp/$JID.sha512.lock" && printf "\\e[1;32mDONE\\e[0m\\n" ; }
	printf "\\e[?25h\\e[1;48;5;101mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash $WDIR: DONE"
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
DLIST=(".idea" "bin" "gen" "gradle" "obj" "out" "output")
FLIST=("*-debug.key" "*.apk"  "*.aar" ".classpath" ".gitignore" ".project" ".settings" "Android.kpf" "ant.properties" "app.iml" "build.gradle" "build.properties" "build.xml" "default.properties" "gradle-wrapper.jar" "gradle-wrapper.properties" "gradlew" "gradlew.bat" "gradle.properties" "gradle.xml" "lint.xml" "local.properties" "makefile.linux_pc" "org.eclipse.jdt.core.prefs" "pom.xml" "proguard.cfg" "proguard-project.txt" "proguard-rules.pro" "project.properties" "R.java" "settings.gradle" "WebRTCSample.iml")
# prep.bash EOF
