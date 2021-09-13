#!/usr/bin/env bash
# Copyright 2019-2021 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 172 173 174 "${0##*/} fandm.bash"
_ANDB_() { # find and process AndroidManifest.xml file
	# if undefined, then define as the first arguement
	[[ -z "${JDR:-}" ]] && JDR=$1
	printf "\\e[1;7;38;5;158m%s\\e[0m\\n" "Searching for job directories in $JDR: Please be patient..."
	# create array of found AndroidManifest.xml files
	AMFS=($(find "$JDR/" -type f -name AndroidManifest.xml))
	# if the number of elements in the array is one, use the singular noun form of the word files, otherwise use the plural form
	[[ "${#AMFS[@]}" = 1 ]] && NAMFILES="file" || NAMFILES="files"
	# if the directory JDR/var/conf exists, write files
	[[ -d "$JDR/var/conf" ]] && printf "%s" "Writing ${#AMFS[@]} AndroidManifest.xml $NAMFILES found to $JDR/var/conf/NAMFS.db  " && printf "%s\\n" "${#AMFS[@]}" > "$JDR/var/conf/NAMFS.db" && printf "%s" "Writing ${AMFS[@]} AndroidManifest.xml $NAMFILES found to $JDR/var/conf/NAMFS.db  " && printf "%s\\n" "${AMFS[@]}" > "$JDR/var/conf/NAMEFS.db"
	for APP in ${AMFS[@]}	# all elements in this array
	do	# cd to directory where file is found
		cd "${APP%/*}" || printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to find the job directory:  Continuing..." # search: string manipulation site:www.tldp.org
		# envoke ` build.one.bash ` in this directory
		"$RDR/scripts/bash/build/build.one.bash" "${APP%/*}" 2>>"$RDR/var/log/stnderr.$JID.log" || printf "\\e[1;7;38;5;220m%s\\e[0m\\n" "Unable to parse jobs in the job directory:  Continuing..."
	done
}
# fandm.bash EOF
