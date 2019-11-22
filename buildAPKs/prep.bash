#!/bin/env bash
# Copyright 2019 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 175 176 177 "${0##*/}" 

_IAR_ () { 
	if [[ -z "${SFX:-}" ]]
	then
		SFX=""
	fi
	if [[ -z "${WDIR:-}" ]]
	then
		WDIR="$JDR/$SFX"
	fi
	_AFR_ || printf "%s prep.bash WARNING: Could not parse _AFR_; Continuing...\\n" "${0##*/}"
}

_AFR_ () { # finds and removes superfluous directories and files
	printf "\\e[?25h\\n\\e[1;48;5;102mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash: Processing elements in directory $WDIR: Please wait..."
	for NAME in "${DLIST[@]}"
	do
 		find "$WDIR" -type d -name "$NAME" -exec rm -rf {} \; 2>/dev/null || : # printf "%s prep.bash WARNING: Could not parse %s in directories list; Continuing...\\n" "${0##*/}" "$NAME" 
		sleep 0.032
	done
	for NAME in "${FLIST[@]}"
	do
 		find "$WDIR" -type f -name "$NAME" -delete || : # printf "%s prep.bash WARNING: Could not parse %s in files list; Continuing...\\n" "${0##*/}" "$NAME"
		sleep 0.032
	done
	find  "$WDIR" -type d -empty -delete || : # printf "%s prep.bash WARNING: Could not parse empty directories; Continuing...\\n" "${0##*/}"
	printf "\\e[?25h\\n\\e[1;48;5;101mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash $WDIR: DONE!"
}

declare -a DLIST # declare array for all superfluous directories
declare -a FLIST # declare array for all superfluous files
DLIST=(".idea" "bin" "gen" "gradle" "obj")
FLIST=("*-debug.key" "*.apk"  "*.aar" "*.jar" ".gitignore" ".project" "Android.kpf" "ant.properties" "app.iml" "build.gradle" "build.properties" "build.xml" ".classpath" "default.properties" "gradle-wrapper.properties" "gradlew" "gradlew.bat" "gradle.properties" "gradle.xml" "lint.xml" "local.properties" "makefile" "makefile.linux_pc" "org.eclipse.jdt.core.prefs" "pom.xml" "proguard.cfg" "proguard-project.txt" "proguard-rules.pro" "project.properties" "R.java" ".settings" "settings.gradle" "WebRTCSample.iml")
# prep.bash EOF
