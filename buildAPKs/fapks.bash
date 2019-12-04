#!/bin/env bash
# Copyright 2019 (c)  all rights reserved by S D Rausty;  see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# adds USENAME and APKs results to files
#####################################################################
set -eu
_APKBC_() {
	NAPKS=($(find "$JDR" -type f -name "*.apk")) # create array of found APK files 
	printf "%s" "Writing ${#NAPKS[@]} built APKs found to $JDR/var/conf/NAPKS.db" # print number of array elements to screen 
	printf "%s\\n" "${#NAPKS[@]}" > "$JDR/var/conf/NAPKS.db" # write number of array elements to file 
	printf "%s" "Writing ${NAPKS[@]##*/} built APK names found to $JDR/var/conf/NAMKS.db" # print array elements to screen 
	printf "%s\\n" "${NAPKS[@]##*/}" > "$JDR/var/conf/NAMKS.db" # write array elements to file 
	if [ "${#NAPKS[@]}" -gt 999 ] # USENAME's work built more than 999 APKs
	then # add USENAME string to B1000NAMES and log/B1000NAMESNAPKs files
		_NAMESMAINBLOCK_ B1000NAMES log/B1000NAMESNAPKs
	fi
	if [ "${#NAPKS[@]}" -gt 99 ] # USENAME's work built more than 99 APKs
	then # add USENAME string to B100NAMES and log/B100NAMESNAPKs files 
		_NAMESMAINBLOCK_ B100NAMES log/B100NAMESNAPKs
	fi
	if [ "${#NAPKS[@]}" -gt 9 ] # USENAME's work built more than 9 APKs
	then # add USENAME string to B10NAMES and log/B10NAMESNAPKs files
		_NAMESMAINBLOCK_ B10NAMES log/B10NAMESNAPKs
	fi
	if [ "${#NAPKS[@]}" -gt 0 ] # USENAME's work built more than 0 APKs
	then # add USENAME string to BNAMES and log/BNAMESNAPKs files
		_NAMESMAINBLOCK_ BNAMES log/BNAMESNAPKs
	fi
	if [ "${#NAPKS[@]}" -eq 0 ] # USENAME's APKs were not built 
	then	# check if AndroidManifest.xml files are found
		if [[ -n $(find "$JDR" -type f -name "AndroidManifest.xml") ]] # AndroidManifest.xml files are found
		then # add USENAME to RNAMES
			_NAMESMAINBLOCK_ RNAMES 
		else # add USENAME to ZNAMES
			_NAMESMAINBLOCK_ ZNAMES 
		fi
	fi
	unset NAPKS
}
# fapks.bash EOF
