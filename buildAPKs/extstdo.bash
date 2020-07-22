#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# External storage installation: This feature is being developed 
#####################################################################
set -eu
. "$RDR/scripts/bash/shlibs/android/extstck.bash" 
_EXTSTCK_

_CP2EXTSTTD_() {
	printf "%s" "Copying $RDR/ to $EXTSTTD/ : " 
	cp -r "$RDR/" "$EXTSTTD/"
	cp -r "$RDR/.*" "$EXTSTTD/${RDR##*/}/"
	printf "%s" "done "
}

_EXTSTDO_() {
	( [[ -w "$EXTSTTD/buildAPKs" ]] && printf "%s" "Continuing with writable external storage $FILENDSTRING installation : Found writable $EXTSTTD/buildAPKs folder : " && export EXTSTBD=0 ) || (printf "%s" "Did not detect writable external storage $EXTSTTD/buildAPKs folder : Continuing with external storage $FILENDSTRING installation : " && _CP2EXTSTTD_ && cd "$EXTSTTD/${RDR##*/}/" && git pull && cd "$RDR" && export EXTSTBD=0 )
	[[ -f "$EXTSTTD/buildAPKs/.conf/VERSIONID" ]] && ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)" && printf "%s" "Found file $EXTSTTD/buildAPKs/.conf/VERSIONID : $ESVERSIONID : " && export EXTSTBD=0 || EXTSTBD=1 


	if [[ "$EXTSTBD" = 0 ]] 
	then
# 		[[ "$EXTSTCK" = 0 ]] && _EXTSTTD_
		ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)"
		[[ "$ESVERSIONID" = 4.7.* ]] && _CP2EXTSTTD_ || printf "%s" "Not continuing with external storage $FILENDSTRING installation : Version mismatch : "
	else
		printf "%s" "Could not find file $EXTSTTD/buildAPKs/.conf/VERSIONID : Not continuing with external storage $FILENDSTRING installation : " && EXTSTBD=1 
	fi
}
FILENDSTRING="${0##*/} extstdo.bash"
[[ -f  $RDR/.conf/EXTSTDO ]] && EXTSTDO="$(head -n 1 $RDR/.conf/EXTSTDO)" && [[ $EXTSTDO = 0 ]] && _EXTSTDO_
printf "%s\\n" "External storage installation : DONE"
# extstdo.bash EOF
