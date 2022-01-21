#!/usr/bin/env bash
# Copyright 2019-2022 (c) all rights reserved
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
		find "$WDIR" -type f -name "$NAME" -delete && ([ -f "$WDIR/sha512.sum" ] && grep "$NAME" "$WDIR/sha512.sum" 1>/dev/null && sed -i "/$NAME/d" "$WDIR/sha512.sum" )
	done
	[ -n "${JDR:-}" ] && [ ! -f "$RDR/var/tmp/${JID:-}.sha512.0" ] && [ -f "$JDR/sha512.sum" ] && { CWDIRPWD="$PWD" && cd "$JDR" && printf "\\e[1;2m%s" "Running 'sha512sum --quiet -c sha512.sum' in directory '$PWD': $(sha512sum --quiet -c sha512.sum)" && cd "$CWDIRPWD" && touch "$RDR/var/tmp/${JID:-}.sha512.0" && printf "\\e[1;32mDONE\\e[0m\\n" ; }
	_DLGDIRS_ || _SIGNAL_ "84" "_DLGDIRS_ _IAR_"
	printf "\\e[?25h\\e[1;48;5;101mBuildAPKs %s\\e[0m\\n" "${0##*/} prep.bash $WDIR: DONE"
}

_DLGDIRS_ () {	# delete '.git' directories
	DELDIRS="$(find "$WDIR" -type d -name \.git)"
	for DELDIR in $DELDIRS
	do
		rm -rf "$DELDIR" && printf '%s\n' "Deleted directory '$DELDIR '."
	done
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
FLIST=("*-debug.key" "*.apk"  "*.aar" ".class" ".classpath" ".gitignore" ".project" ".settings" "Android.kpf" "AndroidManifest.*.xml" "app.iml" "build.properties" "default.properties" "gradle-wrapper.jar" "gradle-wrapper.properties" "gradlew" "gradlew.bat" "gradle.properties" "gradle.xml" "lint.xml" "local.properties" "makefile.linux_pc" "org.eclipse.jdt.core.prefs" "pom.xml" "proguard.cfg" "proguard-project.txt" "proguard-rules.pro" "project.properties" "R.java" "settings.gradle" "WebRTCSample.iml")
LIBAU="$(awk 'NR==1' "$RDR/.conf/LIBAUTH")" # load true/false from .conf/LIBAUTH file.  File LIBAUTH has information about loading artifacts and libraries into the build process.
if [[ "$LIBAU" == true ]]
then	# find and download artifacts and libraries for the build process
_MCLOOKUP_(){
GROUPID="$(cut -d" " -f1 <<< "$ONEDEP")"
ARTIFACTID="$(cut -d" " -f2 <<< "$ONEDEP")"
VERSION="$(cut -d" " -f3 <<< "$ONEDEP")"
[ -f "${ARTIFACTID}-${VERSION}.aar" ] || curl -OL "https://maven.google.com/${GROUPID%%\.*}/${ARTIFACTID}/${ARTIFACTID}/${VERSION}/${ARTIFACTID}-${VERSION}.aar"
[ -f "${ARTIFACTID}-${VERSION}.jar" ] || curl -OL "https://maven.google.com/${GROUPID%%\.*}/${ARTIFACTID}/${ARTIFACTID}/${VERSION}/${ARTIFACTID}-${VERSION}.jar"
}
DEPSLIST="$(find . -name build.gradle -exec grep -e compile -e implementation {} \; | grep -v \/\/ | grep -v fileTree\ \( | grep -v project\ \( | grep -v fileTree\( | grep -v project\( | grep -v Class | grep -v Deps | grep -v \= | sort | uniq)"
WDR="$PWD"
([ -d "$RDR/var/cache/artifacts" ] || mkdir -p "$RDR/var/cache/artifacts") && cd "$RDR/var/cache/artifacts"
for ONEDEP in $DEPSLIST
do
ONEDEP="${ONEDEP//implementation/}"
ONEDEP="${ONEDEP//\'/}"
ONEDEP="${ONEDEP//\"/}"
ONEDEP="${ONEDEP//\:/ }"
_MCLOOKUP_ "$ONEDEP"
done
ARTFILES="$(find . -maxdepth 1 -type f -name "*.*ar")"
for DEPFILE in $ARTFILES
do
	if ! grep "Error 404" "$DEPFILE" 1>/dev/null
	then
		DEPFILELIST+=("${DEPFILE//.\//}")
	fi
done
for DDEPFILE in "${DEPFILELIST[@]}"
do
	DEPDIR="res-$(cut -d"-" -f1 <<< "$DDEPFILE")"
	[ -d "$RDR/var/cache/lib/$DEPDIR" ] || mkdir -p "$RDR/var/cache/lib/$DEPDIR" && cd "$RDR/var/cache/lib/$DEPDIR"
	unzip -oqq "$RDR/var/cache/artifacts/$DDEPFILE" || :
done
cd "$WDR"
fi
# prep.bash EOF
