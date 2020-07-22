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
EXTSTCW="$(wc -w <<< $EXTSTST )"
EXTSTTD="/storage/$EXTSTST/Android/data/com.termux/files"
_EXTSTCK_() { # check if external storage is writable 
	[[ "$EXTSTCW" = 0 ]] && echo "Did not detect writable external storage : Not continuing with external storage feature" && EXTSTCK=1 
	[[ "$EXTSTCW" -ge 2 ]] && echo "Detect multiple writable external storage spaces : Not continuing with external storage feature" && EXTSTCK=1 
	[[ -w "$EXTSTTD" ]] && echo "Detected writable external storage : Continuing with external storage feature" && EXTSTCK=0  
}
# extstck.bash EOF
