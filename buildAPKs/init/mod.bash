#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR/scripts/bash/shlibs/trap.bash" 207 208 209 "${0##*/}" "wake.start" 

_CLINKS_() { 
	ADLINK=(apps buildAPKs buildAPKs.modules clocks compasses developers.tools entertainment flashlights games github live.wallpapers samples top10 tutorials widgets)
	VSTRING="symlink warning: Continuing..."
	VSTRINGC="Creating symlinks: "
	if [[ ! -e "$RDR/update.buildAPKs.sh" ]]
	then
		printf "\\e[1;34m%s" "$VSTRINGC"
		ln -s "$RDR/scripts/sh/shlibs/buildAPKs/maintenance/up.sh" "$RDR/update.buildAPKs.sh" 2>/dev/null || printf "%s\\n" "update.buildAPKs.sh $VSTRING"
		ln -s "$RDR/scripts/sh/shlibs/dctar.sh" "$RDR/scripts/maintenance/delete.corrupt.tars.sh" 2>/dev/null || printf "%s\\n" "delete.corrupt.tars.sh $VSTRING"
		for TYPE in "${ADLINK[@]}"
		do
			ln -s "$RDR/scripts/bash/build/build.$TYPE.bash" "$RDR/build.$TYPE.bash" 2>/dev/null  || printf "%s\\n" "build.$TYPE.bash $VSTRING"
		done
		ln -s "$RDR/scripts/bash/build/buildAll.bash" "$RDR/buildAll.bash" 2>/dev/null || printf "%s\\n" "buildAll.bash $VSTRING"
		ln -s "$RDR/var/cache/stash" "$RDR/stash" 2>/dev/null || printf "%s\\n" "stash $VSTRING"
		printf "\\e[1;32mDONE\\e[0m\\n"
		if [[ -e "$RDR/setup.buildAPKs.bash" ]]
		then
			rm -f "$RDR/setup.buildAPKs.bash"
		fi
	fi
}

_MAINMODS_ () {
	_TMPDIR_ 
	export DAY="$(date +%Y%m%d)"
	export NUM="$(date +%s)"
	export JDR="$RDR/sources/$JID"
	. "$RDR"/scripts/bash/shlibs/buildAPKs/at.bash
	. "$RDR"/scripts/bash/shlibs/buildAPKs/bnchn.bash bch.st 
	. "$RDR"/scripts/bash/shlibs/buildAPKs/fandm.bash 
	. "$RDR"/scripts/sh/shlibs/mkfiles.sh
	. "$RDR"/scripts/sh/shlibs/mkdirs.sh
	_MKDIRS_ "cache/stash" "cache/tarballs" "db" "db/log" "log/messages"
	_MKFILES_ "db/BNAMES" "db/B10NAMES" "db/B100NAMES" "db/CNAMES" "db/ENAMES" "db/GNAMES" "db/QNAMES" "db/RNAMES" "db/XNAMES" "db/ZNAMES"
	_CLINKS_
	if [[ -f "$JDR/.git" ]] # file exists in job directory
	then # print modules message
		_PRINTNMODS_
	else # print updating modules message
		_PRINTUMODS_
		_UMODS_
	fi
	_ANDB_ "$JDR"
	. "$RDR/scripts/bash/shlibs/buildAPKs/tots.bash"
	. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.gt 
}

_PRINTUMODS_() {
	printf "\\e[1;2;38;5;190m%s%s\\e[0m\\n\\n" "Updating buildAPKs: \` ${0##*/} \` might want to load sources from submodule repositories into buildAPKs.  This may take a little while to complete.  Please be patient if this script wants to download source code from https://github.com:" 
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
		 printf "%s" "This temporary directory can be safely deleted if no other jobs are running." > "$TMPDIR/README.md"
	fi
}

_UMODS_() { 
	printf "\\e[1;1;38;5;191m%s\\e[0m\\n" "Updating module ~/${RDR##*/}/sources/$JID to the newest version... " 
	if grep -w $JID .gitmodules 1>/dev/null
	then
		(git submodule update --init --recursive --remote sources/$JID && _IAR_) || printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE ~/${RDR##*/}/sources/$JID:  Continuing..." # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
		if [[ -f "$JDR/ma.bash" ]] 
		then 
			. "$JDR/ma.bash"
		fi
	else
		(git submodule add https://$JAD sources/$JID && git submodule update --init --recursive --remote sources/$JID && _IAR_) || printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT ADD ~/${RDR##*/}/sources/$JID:  Continuing..."
		if [[ -f "$JDR/ma.bash" ]] 
		then 
			. "$JDR/ma.bash"
		fi
	fi
}

if [[ -z "${1:-}" ]]
then
	_MAINMODS_
## [[c|ct] rate] limit download transmission rate for curl.
elif [[ "${1//-}" = [Cc]* ]] || [[ "${1//-}" = [Cc][Tt]* ]]
then # the second option is required
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
