#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# External storage installation: This feature is being developed 
#####################################################################
set -eu
. "$RDR/scripts/bash/shlibs/android/extstck.bash" 
_EXTSTTD_() {
	( [[ -w "$EXTSTTD/buildAPKs" ]] && echo "Detected writable external storage $EXTSTTD/buildAPKs folder" && EXTSTBD=0 ) || (echo "Did not detect writable external storage $EXTSTTD/buildAPKs folder: Copying $RDR/ to $EXTSTTD/" && cp -r "$RDR/" "$EXTSTTD/" && EXTSTBD=0 )
	( [[ -f "$EXTSTTD/buildAPKs/.conf/VERSIONID" ]] && echo -n "Found file $EXTSTTD/buildAPKs/.conf/VERSIONID: " && EXTSTBD=0 ) || ( echo  "Could not find file $EXTSTTD/buildAPKs/.conf/VERSIONID: Not continuing with external storage installation" && EXTSTBD=1 ) 
}
_EXTSTCK_
if [[ "$EXTSTBD" = 0 ]] 
then
	[[ "$EXTSTCK" = 0 ]] && _EXTSTTD_
	ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)"
	[[ "$ESVERSIONID" = 4.7.* ]] && echo echo gt echo gt gt || echo Not continuing with external storage installation: Version mismatch
fi
# extstdo.bash EOF
