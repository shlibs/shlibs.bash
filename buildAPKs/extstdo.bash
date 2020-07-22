#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# External storage installation: This feature is being developed 
#####################################################################
set -eu
. "$RDR/scripts/bash/shlibs/android/extstck.bash" 
_EXTSTCK_

_EXTSTDO_() {
_CP2EXTSTTD_() {
	printf "%s" "Copying $RDR/ to $EXTSTTD/ : " 
	cp -r "$RDR/" "$EXTSTTD/"
	cp -r "$RDR/.*" "$EXTSTTD/${RDR##*/}/"
	printf "%s" "done "
}
	( [[ -w "$EXTSTTD/buildAPKs" ]] && printf "%s" "Found writable $EXTSTTD/buildAPKs folder : " && export EXTSTBD=0 ) || (printf "%s" "Did not detect writable external storage $EXTSTTD/buildAPKs folder : " && _CP2EXTSTTD_ && cd "$EXTSTTD/${RDR##*/}/" && git pull && cd "$RDR" )
 	[[ -f "$EXTSTTD/buildAPKs/.conf/VERSIONID" ]] && ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)" && printf "%s" "Found file $EXTSTTD/buildAPKs/.conf/VERSIONID : $ESVERSIONID : " && export EXTSTBD=0 
printf "%s\\n" "External storage installation : DONE"
}
FILENDSTRING="${0##*/} extstdo.bash"
[[ -f  $RDR/.conf/EXTSTDO ]] && EXTSTDO="$(head -n 1 $RDR/.conf/EXTSTDO)" && [[ $EXTSTDO = 0 ]] && _EXTSTDO_
# extstdo.bash EOF
