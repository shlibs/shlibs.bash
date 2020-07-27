#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# External storage installation: This feature is being developed 
#####################################################################
set -eu
. "$RDR/scripts/bash/shlibs/android/extstck.bash" 
FILEDOSTRING="${0##*/} extstdo.bash"
_EXTSTDO_() {
_CK2EXTSTBD_() {
	( [[ -w "$EXTSTTD/buildAPKs" ]] && printf "%s" "$FILEDOSTRING found writable $EXTSTTD/buildAPKs folder : " && EXTSTBD=0 ) || ( printf "%s" "$FILEDOSTRING did not detect writable external storage $EXTSTTD/buildAPKs folder : " && ( _CP2EXTSTTD_ && _TOUCHUP_ ) )
	[[ -f "$EXTSTTD/buildAPKs/.conf/VERSIONID" ]] && ESVERSIONID="$(head -n 1 $EXTSTTD/buildAPKs/.conf/VERSIONID)" && printf "%s" "$FILEDOSTRING found file $EXTSTTD/buildAPKs/.conf/VERSIONID : $ESVERSIONID : " && EXTSTBD=0
printf "%s\\n" "External storage installation : $FILEDOSTRING DONE"
}
_CP2EXTSTTD_() {
	printf "%s" "Copying $RDR/ to $EXTSTTD/ : Please be patient : "
	cp -a "$RDR/" "$EXTSTTD/"
	printf "%s" "DONE : "
}
_TOUCHUP_() {
	printf "%s" "Moving and linking directories : "
	mv "$RDR/var/log" "$RDR/var/cache/stash/"
	ln -s "$EXTSTTD/buildAPKs/var/log" "$RDR/var/log" 
	mv "$RDR/var/cache/tarballs" "$RDR/var/cache/stash/"
	ln -s "$EXTSTTD/buildAPKs/var/cache/tarballs" "$RDR/var/cache/tarballs"
	[[ -d $RDR/sources ]] && mv "$RDR/sources" "$RDR/var/cache/stash/" || printf "%s\\n" "Signal generated at mv $RDR/sources ${0##*/} extstdo.bash : Continuing : "
	[[ -d $EXTSTTD/buildAPKs/sources ]] && ln -s "$EXTSTTD/buildAPKs/sources" "$RDR/sources" || printf "%s\\n" "Signal generated at ln -s $EXTSTTD/buildAPKs/sources ${0##*/} extstdo.bash : Continuing : "

}
[[ "$EXTSTCK" = 0 ]] && _CK2EXTSTBD_
}
( [[ -f  $RDR/.conf/EXTSTDO ]] && EXTSTDO="$(head -n 1 $RDR/.conf/EXTSTDO)" && [[ $EXTSTDO = 0 ]] && _EXTSTCK_ && _EXTSTDO_ )
# extstdo.bash EOF
