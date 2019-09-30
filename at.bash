#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SATTRPERROR_() { # run on script error
	local RV="$?"
	echo "$RV" at.bash
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs %s ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${PWD##*/}" "${1:-UNDEF}" "${2:-LINENO}" "${3:-BASH_COMMAND}"
	exit 157
}

_SATTRPEXIT_() { # run on exit
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SATTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Signal %s received!\\e[0m\\n" "at.bash" "$RV"
 	exit 158 
}

_SATTRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "at.bash" "$RV"
 	exit 159 
}

trap '_SATTRPERROR_ $? $LINENO $BASH_COMMAND' ERR 
trap _SATTRPEXIT_ EXIT
trap _SATTRPSIGNAL_ HUP INT TERM 
trap _SATTRPQUIT_ QUIT 

_TB_() { # add git modules from GitHub to cache directory
	if [[ -f "$RDR/cache/tarballs/$2" ]]
       	then
		(cd "$JDR/$1/" ; printf "\\n%s\\n" "Populating $JDR/$1/:" ; tar xf "$RDR/cache/tarballs/$2" ; export SFX="$1" ; _AFR_ ) || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE:  Continuing...")
	else
		(cd "$RDR"/cache/tarballs/ ; printf "\\n%s\\n" "Getting https://github.com/$1/tarball/$2" ; curl -OL https://github.com/$1/tarball/$2 ; cd "$JDR/$1/" ; printf "\\n%s\\n" "Populating $JDR/$1/:" ; tar xf "$RDR/cache/tarballs/$2" ; export SFX="$1" ; _AFR_ ) || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE:  Continuing...")
	fi
}

_AT_() { # unused : add git modules from GitHub to job directory
	if [[ -d "$JDR/$1/" ]]
       	then
		if ! find "$JDR/$1/" -type f -name AndroidManifest.xml
       		then
			_TB_ "$@"
		fi	
	else
		mkdir -p "$JDR/$1/"
		_TB_ "$@"
	fi
}

# at.bash EOF
