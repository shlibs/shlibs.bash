#!/usr/bin/env bash
# Copyright 2017-2020 (c) all rights reserved
# by buildAPKs https://buildapks.github.io/docsBuildAPKs/
# Update repository and update submodules.
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
RDR="$HOME/buildAPKs"
. "$RDR/scripts/bash/shlibs/trap.bash" 180 181 182 "${0##*/} build.buildAPKs.modules.bash"

_2GSU_() {
	if [[ "$SBMI" = "" ]]
	then
 		printf "To update the modules in ~/%s to the newest version remove these .git files:\\n\\n~/%s/scripts/bash/shlibs/.git\\n" "${RDR##*/}" "${RDR##*/}"
		for GLOC in "${!GBMS[@]}"
		do
			printf "%s\\n" "~/${RDR##*/}/$GLOC/.git"
		done
 		printf "\\nUse find to update the modules in ~/buildAPKs/ to the newest version:\\n\\n"
 		printf "	find ~/buildAPKs/ -type f -name .git -delete"
 		printf "\\n\\nThen run %s again, and %s shall attempt to update them all.\\n" "${0##*/}" "${0##*/}"
	else
		_GSMU_
	fi
}

_CK4MS_() { # ChecKs 4 ModuleS
	SBMI=""
	for ALOC in "${!GBMS[@]}"
	do
		if [[ ! -f "$RDR/$ALOC/.git" ]]
		then
			SBMI=1
			break
		fi
	done
}

_GSA_() { # update submodules to latest version
	((printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Adding $SIAD/${GBMS[$LOC]} to ~/buildAPKs/$LOC..." && git submodule add "$SIAD/${GBMS[$LOC]}" "$LOC") && (printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Updating ~/${RDR##*/}/$LOC..." && git submodule update --init --recursive --remote "$LOC" && _IAR_ "$JDR")) ||  (printf "\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot add and update ~/${RDR##*/}/$LOC: Continuing...")
}

_GSMU_() {
	printf "\\e[1;7;38;5;114mUpdating buildAPKs; \\e[1;7;38;5;112m%s\\e[1;7;38;5;114m shall attempt to load sources from git submodule repositories into \\e[1;7;38;5;113m~/%s\\e[1;7;38;5;114m.  This may take a little while to complete.  Please be patient while \\e[1;7;38;5;112m%s\\e[1;7;38;5;114m downloads source code from \\e[1;7;38;5;113m%s:\\e[0m\\n" "${0##*/}" "${RDR##*/}" "${0##*/}" "$SIAD"
	. "$RDR"/scripts/bash/init/ushlibs.bash
	. "$RDR"/scripts/bash/shlibs/buildAPKs/at.bash
	. "$RDR"/scripts/bash/shlibs/buildAPKs/prep.bash
	. "$RDR"/scripts/bash/shlibs/lock.bash
	if [[ ! -d "$RDR/sources" ]]
	then
		mkdir -p "$RDR/sources"
	fi
	for LOC in "${!GBMS[@]}"
	do
		export JDR="$RDR/$LOC"
		cd "$RDR/"
		_GSU_
	done
	_WAKEUNLOCK_
	printf "\\e[1;7;38;5;114mBuildAPKs %s build.buildAPKs.modules.bash: DONE!\\e[0m\\n" "${0##*/}"
}

_GSU_() { # update submodules to latest version
	((printf "\\e[1;7;38;5;96m%s\\e[0m\\n" "Updating ~/buildAPKs/$LOC..." && git submodule update --init --recursive --remote "$LOC" && _IAR_ "$JDR") || ( _GSA_ )) ||  (printf "\\e[1;7;38;5;66m%s\\e[0m\\n" "Cannot update ~/buildAPKs/$LOC: Continuing...") # https://www.tecmint.com/chaining-operators-in-linux-with-practical-examples/
	if [[ -f "$JDR"/ma.bash ]]
	then
		. "$JDR"/ma.bash
	fi
}

declare -A GBMS # declare associative array for available submoldules
export GBMS=([sources/applications]="SDRausty/buildAPKsApps"  [sources/apps]="BuildAPKs/buildAPKs.apps" [sources/bits]="BuildAPKs/buildAPKs.bits" [sources/browsers]="SDRausty/buildAPKsBrowsers" [sources/clocks]="BuildAPKs/buildAPKs.clocks" [sources/compasses]="BuildAPKs/buildAPKs.compasses" [sources/demos]="BuildAPKs/buildAPKs.demos" [sources/entertainment]="BuildAPKs/buildAPKs.entertainment" [sources/flashlights4]="BuildAPKs/buildAPKs.flashlights" [sources/gamez]="BuildAPKs/buildAPKs.games" [sources/gaming]="SDRausty/buildAPKsGames" [sources/hellos]="BuildAPKs/buildAPKs.hellos" [sources/launchers]="BuildAPKs/buildAPKs.launchers" [sources/live.wallpapers]="BuildAPKs/buildAPKs.live.wallpapers" [sources/samples4]="SDRausty/buildAPKsSamples" [sources/samps]="BuildAPKs/buildAPKs.samples" [sources/top10]="SDRausty/buildAPKsTop10" [sources/tools]="BuildAPKs/buildAPKs.developers.tools" [sources/torches]="SDRausty/buildAPKsFlashlights" [sources/tutorials]="SDRausty/buildAPKsTutorials" [sources/widgets]="SDRausty/buildAPKsWidgets" [sources/widgets4]="BuildAPKs/buildAPKsWidgets")
SIAD="git://github.com"
if [[ -z "${1:-}" ]]
then
	cd "$RDR/"
	_CK4MS_
	_2GSU_
fi
# build.buildAPKs.modules.bash EOF
