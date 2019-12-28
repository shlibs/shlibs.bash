#!/bin/env bash
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/shlibs/trap.bash 116 117 118 "${0##*/} calib.bash" 
_MAINCALIB_() {
	if [[ -f "$RDR"/.conf/LIBAUTH ]] 
	then
		PV1="$(head -n 1 "$RDR"/.conf/LIBAUTH)"
		PV1="$(awk '{print $1}' <<< $PV1)"
		if [[ "$PV1" == "false" ]] 
		then
			printf "%s\\n" "$(cat "$RDR"/.conf/LIBAUTH) "
		fi
	fi
}
_MAINCALIB_
# calib.bash EOF
