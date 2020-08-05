#!/usr/bin/env bash
# Copyright 2017-2020 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/shlibs/trap.bash" 207 208 209 "${0##*/} mod.bash" "wake.start"

_CLINKS_() {
	ADLINK=(apps buildAPKs clocks compasses demos developers.tools entertainment flashlights games launchers live.wallpapers native samples top10 tutorials widgets)
	VSTRING="symlink warning: Continuing...  "
	VSTRINGC="Creating symlinks:  "
	if [ ! -e "$RDR/update.buildAPKs.sh" ]
	then
		printf "\\e[1;34m%s" "$VSTRINGC"
		ln -s "$RDR/scripts/sh/shlibs/buildAPKs/maintenance/up.sh" "$RDR/update.buildAPKs.sh" || printf "%s\\n" "update.buildAPKs.sh $VSTRING"
		if [ ! -e  "$RDR/scripts/maintenance/delete.corrupt.tars.sh" ]
		then
			ln -s "$RDR/scripts/sh/shlibs/dctar.sh" "$RDR/scripts/maintenance/delete.corrupt.tars.sh" || printf "%s\\n" "delete.corrupt.tars.sh $VSTRING"
		fi
		for TYPE in "${ADLINK[@]}"
		do
			if [ ! -e "$RDR/build.$TYPE.bash" ]
			then
				ln -s "$RDR/scripts/bash/build/build.$TYPE.bash" "$RDR/build.$TYPE.bash" || printf "%s\\n" "build.$TYPE.bash $VSTRING"
			fi
		done
		if [ ! -e "$RDR/build.github.bash" ] && [ -e "$RDR/opt/api/github/build.github.bash" ]
		then
			ln -s "$RDR/opt/api/github/build.github.bash" "$RDR/build.github.bash" || printf "%s\\n" "build.github.bash $VSTRING"
		fi
		if [ -f "$RDR/opt/api/github/.git" ]
		then
			ln -s "$RDR/opt/api/github" "$RDR/scripts/bash/github" || printf "%s\\n" "github $VSTRING"
		fi
		if [ ! -e "$RDR/build.github.bash" ] && [ -e "$RDR/scripts/bash/github/build.github.bash" ]
		then
			ln -s "$RDR/scripts/bash/github/build.github.bash" "$RDR/build.github.bash" || printf "%s\\n" "build.github.bash $VSTRING"
		fi
		[ ! -e "$RDR/stash" ] && ln -s "$RDR/var/cache/stash" "$RDR/stash" || printf "%s\\n" "stash $VSTRING"
		[ -e "$RDR/setup.buildAPKs.bash" ] && mv "$RDR/setup.buildAPKs.bash" "$RDR/scripts/bash/init/setup.buildAPKs.bash"
		printf "\\e[1;32mDONE\\e[0m\\n"
	fi
}

_MAINMODS_ () {
	# create TMPDIR in RDR/var if not exist
	_TMPDIR_
	export DAY="$(date +%Y%m%d)"
	export NUM="$(date +%s)"
	export JDR="$RDR/sources/$JID"
	. "$RDR"/scripts/bash/shlibs/buildAPKs/at.bash
	. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st
	[[ $(head -n 1 "$RDR"/.conf/EXTSTDO) -eq 0 ]] && . "$RDR"/scripts/bash/shlibs/buildAPKs/extstdo.bash
	. "$RDR"/scripts/bash/shlibs/buildAPKs/fandm.bash
	. "$RDR"/scripts/sh/shlibs/mkfiles.sh
	. "$RDR"/scripts/sh/shlibs/mkdirs.sh
	# create directories and files in RDR/var if not exist
	_MKDIRS_ "cache/stash" "cache/tarballs" "db" "db/log" "lock" "log/messages" "log/github/orgs" "log/github/users" "run/lock/auth" "run/lock/wake"
	_MKFILES_ "db/BNAMES" "db/B10NAMES" "db/B100NAMES" "db/ENAMES" "db/GNAMES" "db/QNAMES" "db/XNAMES" "db/YNAMES" "db/ZNAMES"
	# create symlinks in RDR if not exist
	_CLINKS_
	if [ -f "$JDR/.git" ] # file exists in job directory
	then	# print modules message
		_PRINTNMODS_
	else	# print updating modules message and update modules
		_PRINTUMODS_
		_UMODS_
	fi
	_ANDB_ "$JDR"
	. "$RDR/scripts/bash/shlibs/buildAPKs/tots.bash"
	. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.gt
}

_PRINTUMODS_() {
	printf "\\e[1;2;38;5;190m%s%s\\e[0m\\n\\n" "Updating buildAPKs: \` ${0##*/} mod.bash \` is loading sources from submodule repositories into buildAPKs.  This may take a little while to complete.  Please be patient if this script wants to download source code from https://github.com:"
}

_PRINTUSAGE_() {
	printf "\\e[7;31m%s\\e[0;31m%s\\e[0m\\n" "Run ${0##*/} mod.bash without options to build APKs." " Exiting..."
}

_PRINTNMODS_() {
	printf "\\e[1;7;38;5;100m%s%s\\e[0m\\n" "To update module ~/${RDR##*/}/sources/$JID to the newest version remove the ~/${RDR##*/}/sources/$JID/.git file and run ${0##*/} again."
}

_TMPDIR_ () {
	export TMPDIR="$RDR/var/tmp"
	if [[ ! -d "$TMPDIR" ]]
	then
		 mkdir -p "$TMPDIR"
	fi
}

_UMODS_() {
_GTSAM_() {	# clone submodule as git repository
	if [[ ! -f "$JDR/.git/config" ]]
	then
		printf "%s\\n" "Checking HEAD branch in git://$JAD..."
		RBRANCH="$(git remote show git://$JAD | grep "HEAD branch" | cut -d ":" -f 2)"
		RBRANCH="${RBRANCH# }" # strip leading space
		cd "$RDR/sources"
		printf "%s\\n" "Getting branch $RBRANCH from git repository git://$JAD..."
		git clone --depth 1 git://"$JAD" --branch $RBRANCH --single-branch "${JDR##*/}"  ; cd $JDR ; git fsck || ( cd $JDR && _SIGNAL_ "32" "_GTGF_ git clone" )
	else
		_GRUP_ ; git fsck || ( cd $JDR && _SIGNAL_ "32" "_GTGF_ git clone" )
	fi
	_IAR_ "$JDR/$JDR" || _SIGNAL_ "34" "_GTGF_ _IAR_"
}
_GRUP_() {	# clone submodule as git repository
	cd "$JDR"
	git pull || _SIGNAL_ "36" "git pull _GTGF_ _UMODS_"
}
	printf "\\e[1;1;38;5;191m%s\\e[0m\\n" "Updating module ~/${RDR##*/}/sources/$JID to the newest version... "
	if grep -w "$JID" .gitmodules 1>/dev/null
	then
		( git submodule update --init --recursive --remote "sources/${JDR##*/}" && _IAR_ || _GRUP_ ) || printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE ~/${RDR##*/}/sources/$JID:  Continuing..." # chaining operators
		if [[ -f "$JDR/ma.bash" ]]
		then
			. "$JDR/ma.bash"
		fi
	else
		( git submodule add --depth 1 git://"$JAD" "sources/${JDR##*/}" && _IAR_ || _GTSAM_ ) || printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT ADD ~/${RDR##*/}/sources/$JID:  Continuing..."
		if [[ -f "$JDR/ma.bash" ]]
		then
			. "$JDR/ma.bash"
		fi
	fi
}

if [[ -z "${1:-}" ]] # undefined
then
	_MAINMODS_
## [[c]url rate] limit download transmission rate for curl
elif [[ "${1//-}" = 0 ]]
then	# do nothing
	:
elif [[ "${1//-}" = [Cc]* ]]
then	# the second option is required
	if [[ -z "${2:-}" ]]
	then
		printf "\\e[1;31m%s\\e[0;31m%s\\e[0m\\n" "Add a numerical rate limit to ${0##*/} $1 as the second arguement to continue with curl --rate-limit:" " Exiting..."
		exit 0
	else
		CULR="$2"
		_MAINMODS_
	fi
else
	_PRINTUSAGE_
fi
# mod.bash EOF
