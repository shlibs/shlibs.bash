#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Compares total builds with total deposited APKs. 
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_STOTRPERROR_ () { # Run on script error.
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs tots.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${1:-UNDEFINED}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 197
}

_STOTRPEXIT_ () { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		printf "%s\\n" "BuildAPKs tots.bash EXIT: Signal $RV received by ${0##*/}!"
        fi
	cd "$RDR" 
	rm -rf "$TMPDIR"/fa$$
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_STOTRPSIGNAL_ () { # Run on signal.
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs tots.bash WARNING:  Signal %s received!\\e[0m\\n" "$?"
 	exit 198 
}

_STOTRPQUIT_ () { # Run on quit.
	_WAKEUNLOCK_
        printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs tots.bash WARNING:  Quit script %s received near or at line number %s by \`%s\`!\\e[0m\\n" "${1:-UNDEFINED}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 199 
}

trap '_STOTRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _STOTRPEXIT_ EXIT
trap _STOTRPSIGNAL_ HUP INT TERM 
trap '_STOTRPQUIT_ $? $LINENO $BASH_COMMAND' QUIT 

mkdir -p "$TMPDIR/fa$$"
printf "\\e[1;1;38;5;118m%s\\n\\n" "Calculating for ~/${RDR##*/}/.  This may take a while;  Please be patient."
find "$RDR/sources/" -type f -name AndroidManifest.xml > "$TMPDIR/fa$$/possible.total" 
find "$RDR/sources/" -type f -name "*.apk" > "$TMPDIR/fa$$/built.total" 
find "$JDR" -type f -name AndroidManifest.xml > "$TMPDIR/fa$$/possible" ||: 
find "$JDR" -type f -name "*.apk" > "$TMPDIR/fa$$/built" ||: 
cd "$TMPDIR/fa$$"
printf "\\e[1;1;38;5;119m%s\\n\\n" "The total increases as modules are added;  The build scripts add modules and create APKs on device.  Results for ~/${RDR##*/}/sources/:"
wc -l possible.total built.total | sed -n 1,2p # https://www.cyberciti.biz/faq/unix-linux-show-first-10-20-lines-of-file/
printf "\\n\\e[1;1;38;5;120m%s\\n\\n" "Results for ~/${RDR##*/}/sources/$JID/:" 
wc -l possible built | sed -n 1,2p 
if [[ -d "/storage/emulated/0/Download/builtAPKs/$JID$DAY" ]]
then
       printf "\\n\\e[1;1;38;5;121m%s\\n\\n	%s%s\\n	%s%s\\n" "Results for Download/builtAPKs/:" "$(find /storage/emulated/0/Download/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in Download/builtAPKs/" "$(( $(ls -Al "/storage/emulated/0/Download/builtAPKs/$JID$DAY"/ | wc -l) - 1 ))" " deposited in Download/builtAPKs/$JID$DAY/"
else
       printf "\\n\\e[1;1;38;5;122m%s\\n\\n	%s%s\\n	%s%s\\n" "Results for ~/${RDR##*/}/cache/builtAPKs/:" "$(find "$RDR"/cache/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in ~/${RDR##*/}/cache/builtAPKs/" "$(( $(ls -Al "$RDR/cache/builtAPKs/$JID$DAY" | wc -l) - 1 ))" " deposited in ~/${RDR##*/}/cache/builtAPKs/$JID$DAY/"
fi
BBSL="$(ls "$RDR/scripts/bash/build/")"
printf "\\n\\e[1;1;38;5;108m%s\\n\\n%s\\n" "Build APKs (Android Package Kits) with scripts in ~/${RDR##*/}/scripts/bash/build/:" "$BBSL" 
_WAKEUNLOCK_

# EOF tots.bash
