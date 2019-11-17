#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 172 173 174 "${0##*/}" 
_ANDB_() {
	if [[ -z "${JDR:-}" ]]
	then 
		JDR=$1
	fi
	printf "\\e[1;7;38;5;222m%s\\e[0m\\n" "Searching for job directories with jobs in $JDR: Please be patient..."
	for APP in $(find "$JDR" -type f -name AndroidManifest.xml) 
	do 
		cd "${APP%/*}" || printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to find the job directory:  Continuing..." # search: string manipulation site:www.tldp.org
		"$RDR/scripts/bash/build/build.one.bash" "${APP%/*}" 2>>"$RDR/var/log/stnderr.$JID.log" || printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to parse jobs in the job directory:  Continuing..."
	done
}
# fandm.bash EOF
