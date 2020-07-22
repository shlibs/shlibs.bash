#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# External storage installation: This feature is being developed 
#####################################################################
set -eu
. "$RDR/scripts/bash/shlibs/android/extstck.bash" 

_CP2EXTSTTD_() {
	echo Continuing with external storage installation : Copying $RDR/ to $EXTSTTD/
	cp -r "$RDR/" "$EXTSTTD/"
}

_EXTSTDO_() {
	( [[ -w "$EXTSTTD/buildAPKs" ]] && echo "Detected writable external storage : Continuing with external storage feature$EXTSTTD/buildAPKs folder" && export EXTSTBD=0 ) || (echo -n "Did not detect writable external storage $EXTSTTD/buildAPKs folder : Not continuing with external storage feature" && _CP2EXTSTTD_ && export EXTSTBD=0 )
	[[ -f "$EXTSTTD/buildAPKs/.conf/VERSIONID" ]] && ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)" && echo -n "Found file $EXTSTTD/buildAPKs/.conf/VERSIONID : $ESVERSIONID" && export EXTSTBD=0 || EXTSTBD=1 


	_EXTSTCK_
	echo "$EXTSTTD"
	if [[ "$EXTSTBD" = 0 ]] 
	then
# 		[[ "$EXTSTCK" = 0 ]] && _EXTSTTD_
		ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)"
		[[ "$ESVERSIONID" = 4.7.* ]] && _CP2EXTSTTD_ || echo Not continuing with external storage installation : Version mismatch
	else
		echo "Could not find file $EXTSTTD/buildAPKs/.conf/VERSIONID : Not continuing with external storage installation" && EXTSTBD=1 
	fi
}
[[ -f  $RDR/.conf/EXTSTDO ]] && EXTSTDO="$(head -n 1 $RDR/.conf/EXTSTDO)" && [[ $EXTSTDO = 0 ]] && _EXTSTDO_
# extstdo.bash EOF
