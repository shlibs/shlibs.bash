#!/bin/env bash 
# Copyright 2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 172 173 174 "${0##*/} fandm.bash" 
_ANDB_() {
	if [[ -z "${JDR:-}" ]] # JDR is not defined
	then	# define the first arguement as JDR 
		JDR=$1
	fi
	printf "\\e[1;7;38;5;222m%s\\e[0m\\n" "Searching for job directories in $JDR: Please be patient..."
	AMFS=($(find "$JDR" -type f -name AndroidManifest.xml)) # create array of found AndroidManifest.xml files  
	[[ "${#AMFS[@]}" = 1 ]] && NAMFILES="file" || NAMFILES="files" # if the number of elements in the array is one, use the singular noun form, otherwise use the plural form
	[[ -d "$JDR/var/conf" ]] && printf "%s" "Writing ${#AMFS[@]} AndroidManifest.xml $NAMFILES found to $JDR/var/conf/NAMFS.db  " && printf "%s\\n" "${#AMFS[@]}" > "$JDR/var/conf/NAMFS.db" # if the directory $JDR/var/conf exists, write file
	for APP in ${AMFS[@]} # all elements in array 
	do	# process every AndroidManifest.xml file found  
		cd "${APP%/*}" || printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to find the job directory:  Continuing..." # search: string manipulation site:www.tldp.org
		"$RDR/scripts/bash/build/build.one.bash" "${APP%/*}" 2>>"$RDR/var/log/stnderr.$JID.log" || printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to parse jobs in the job directory:  Continuing..."
	done
}
# fandm.bash EOF
