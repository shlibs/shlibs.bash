#!/bin/env bash
# Copyright 2017-2020 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 166 167 168 "${0##*/}" 

_AT_ () { 
	export SFX="$1" 
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

_PTG_ () { # process a *.tar.gz file for errors
	if ! tar tf "$1" 1>/dev/null
	then
		rm -f "$1"
	fi
}

_TB_ () { # add git modules from GitHub to cache directory
	if [[ ! -d "$RDR/var/cache/tarballs" ]]
       	then
		mkdir -p "$RDR/var/cache/tarballs"
	fi
	if [[ -f "$RDR/var/cache/tarballs/$2" ]]
       	then
		(cd "$JDR/$1/" ; printf "\\n%s\\n" "Populating $JDR/$1/:" ; (tar xvf "$RDR/var/cache/tarballs/$2" | grep AndroidManifest.xml) ; export WDIR="$PWD" ; _IAR_ ) || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE:  Continuing...")
	else
		if [[ ! -z "${CULR:-}" ]]
	        then	# curl limit rate to CULR
	                (cd "$RDR"/var/cache/tarballs/ ; printf "\\n%s\\n" "Getting https://github.com/$1/tarball/$2" ; curl --limit-rate $CULR -OL https://github.com/$1/tarball/$2 ; _PTG_ "$2" ; cd "$JDR/$1/" ; printf "\\n%s\\n" "Populating $JDR/$1/:" ; (tar xvf "$RDR/var/cache/tarballs/$2" | grep AndroidManifest.xml) ; export WDIR="$PWD" ; _IAR_ ) || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE:  Continuing...")
	        else	# get files with no rate limit
	                (cd "$RDR"/var/cache/tarballs/ ; printf "\\n%s\\n" "Getting https://github.com/$1/tarball/$2" ; curl -OL https://github.com/$1/tarball/$2 ; _PTG_ "$2" ; cd "$JDR/$1/" ; printf "\\n%s\\n" "Populating $JDR/$1/:" ; (tar xvf "$RDR/var/cache/tarballs/$2" | grep AndroidManifest.xml) ; export WDIR="$PWD" ; _IAR_ ) || (printf "\\n\\n\\e[1;1;38;5;190m%s%s\\e[0m\\n" "CANNOT UPDATE:  Continuing...")
	        fi
	fi
}

# at.bash EOF
