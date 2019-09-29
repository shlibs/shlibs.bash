#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
# Benchmarks attempted builds and deposited APKs. 
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SBMTRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV ${0##*/}" bnchn.bash
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs bnchn.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${3:-UNKNOWN}" "${1:-LINENO}" "${2:-BASH_COMMAND}"
	exit 194
}

_SBMTRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		printf "%s\\n" "Signal $RV received by ${0##*/}!"  
	fi
	cd "$RDR" 
	rm -rf "$TMPDIR"/fa$$
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SBMTRPSIGNAL_() { # Run on signal.
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs bnchn.bash WARNING:  Signal %s received!\\e[0m\\n" "$?"
	_WAKEUNLOCK_
 	exit 195 
}

_SBMTRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs bnchn.bash WARNING:  Quit signal %s received!\\e[0m\\n" "$?"
	_WAKEUNLOCK_
 	exit 196 
}

trap '_SBMTRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SBMTRPEXIT_ EXIT
trap _SBMTRPSIGNAL_ HUP INT TERM 
trap _SBMTRPQUIT_ QUIT 

if [[ "$1" = "bch.st" ]] 
then 
	ST="$NUM"
elif [[ "$1" = "bch.gt" ]] 
then 
	ET="$(date +%s)"
	printf "Build time: %s seconds\\n\\n" "$(( $ET-$ST ))"
fi

# bnchn.bash OEF
