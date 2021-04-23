#!/usr/bin/env bash
# Copyright 2019-2021 (c) all rights reserved by SDRausty; see LICENSE
# https://sdrausty.github.io hosted courtesy https://pages.github.com
# Detect external storage: This feature is being developed
#####################################################################
set -eu
EXTSTST="$(ls /storage/)"
EXTSTST="${EXTSTST/self/}"
EXTSTST="${EXTSTST/emulated/}"
EXTSTST="$(printf %s $EXTSTST)"
EXTSTCW="$(wc -w <<< $EXTSTST)"
EXTSTTD="/storage/$EXTSTST/Android/data/com.termux/files"
FILECKSTRING="${0##*/} extstck.bash"
_EXTSTCK_() {
	# check if external storage space was found
	[[ "$EXTSTCW" = 0 ]] && printf "%s" "Did not detect writable external storage : Not continuing with external storage $FILECKSTRING feature : " && export EXTSTCK=1
	# check if multiple external storage space were found
	[[ "$EXTSTCW" -ge 2 ]] &&  printf "%s" "Detected multiple writable external storage spaces : Not continuing with external storage $FILECKSTRING feature : This feature is being developed : " && export EXTSTCK=1
	# check if external storage space is writable
	[[ -w "$EXTSTTD" ]] &&  printf "%s" "Detected writable external $EXTSTTD storage space : $FILECKSTRING continuing : " && export EXTSTCK=0
	printf "%s" "Check external storage installation $FILECKSTRING : DONE : "
}
# extstck.bash EOF
