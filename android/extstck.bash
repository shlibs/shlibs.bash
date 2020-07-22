#!/usr/bin/env bash
# Copyright 2019-2020 (c) all rights reserved by SDRausty; see LICENSE  
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# Detect external storage: This feature is being developed 
#####################################################################
set -eu
EXTSTST="$(ls /storage/)"
EXTSTST="${EXTSTST/self/}"
EXTSTST="${EXTSTST/emulated/}"
EXTSTST="$(echo -n $EXTSTST)"
EXTSTCW="$(wc -w <<< $EXTSTST)"
EXTSTTD="/storage/$EXTSTST/Android/data/com.termux/files"
FILENSTRING="${0##*/} extstck.bash"
_EXTSTCK_() { # check if external storage is writable 
	[[ "$EXTSTCW" = 0 ]] && printf "%s" "Did not detect writable external storage : Not continuing with external storage $FILENSTRING feature: " && export EXTSTCK=1 
	[[ "$EXTSTCW" -ge 2 ]] &&  printf "%s" "Detect multiple writable external storage spaces : Not continuing with external storage $FILENSTRING feature : " && export EXTSTCK=1 
	[[ -w "$EXTSTTD" ]] &&  printf "%s" "Detected writable external storage : Continuing with external storage $FILENSTRING feature : " && export EXTSTCK=0  
}
# extstck.bash EOF
