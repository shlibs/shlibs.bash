#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# External storage installation: This feature is being developed 
#####################################################################
set -eu
. "$RDR/scripts/bash/shlibs/android/extstck.bash" 
_EXTSTDO_() {
_CK2EXTSTBD_() {
	( [[ -w "$EXTSTTD/buildAPKs" ]] && printf "%s" "$FILENDSTRING found writable $EXTSTTD/buildAPKs folder : " && export EXTSTBD=0 ) || ( printf "%s" "$FILENDSTRING did not detect writable external storage $EXTSTTD/buildAPKs folder : " && _CP2EXTSTTD_ && cd "$EXTSTTD/${RDR##*/}/" && git pull && cd "$RDR" ) && export EXTSTBD=0
 	[[ -f "$EXTSTTD/buildAPKs/.conf/VERSIONID" ]] && ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)" && printf "%s" "$FILENDSTRING found file $EXTSTTD/buildAPKs/.conf/VERSIONID : $ESVERSIONID : " && export EXTSTBD=0 || printf "%s" "$FILENDSTRING did not find file $EXTSTTD/buildAPKs/.conf/VERSIONID : ${ESVERSIONID:noESVERSIONID} : " && export EXTSTBD=1   
printf "%s\\n" "EXTSTBD is set to $EXTSTBD"
printf "%s\\n" "ESVERSIONID is set to $ESVERSIONID" 
printf "%s\\n" "External storage installation $FILENDSTRING: DONE"
}
_CP2EXTSTTD_() {
	printf "%s" "Copying $RDR/ to $EXTSTTD/ : " && cp -r "$RDR/" "$EXTSTTD/" && cp -r "$RDR/.*" "$EXTSTTD/${RDR##*/}/" && printf "%s" "done "
}
_CK2EXTSTBD_
}
FILENDSTRING="${0##*/} extstdo.bash"
[[ -f  $RDR/.conf/EXTSTDO ]] && EXTSTDO="$(head -n 1 $RDR/.conf/EXTSTDO)" && [[ $EXTSTDO = 0 ]] && _EXTSTCK_ && _EXTSTDO_
# extstdo.bash EOF
