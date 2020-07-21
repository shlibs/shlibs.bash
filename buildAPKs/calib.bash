#!/usr/bin/env bash
# Copyright 2017-2020 (c) all rights reserved
# by S D Rausty https://sdrausty.github.io
# Display message to terminal upon initail builds.
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/shlibs/trap.bash 116 117 118 "${0##*/} calib.bash"
# create directory if not found
[[ ! -d "$RDR"/var/tmp/ ]] && mkdir -p "$RDR"/var/tmp/
# create and write initial display count to file
[[ ! -f "$RDR"/var/tmp/CALIB.cn ]] && printf 0 > "$RDR"/var/tmp/CALIB.cn
# read display count from file; iterate and write display count to file
CALIBCT="$(awk '{print $1}' "$RDR"/var/tmp/CALIB.cn)" && CALIBCT="$(( CALIBCT + 1 ))" && printf "%s" "$CALIBCT" > "$RDR"/var/tmp/CALIB.cn

_MAINCALIB_() { # print information to terminal from file .conf/LIBAUTH
	if [[ -f "$RDR"/.conf/LIBAUTH ]]
	then
		PV1="$(head -n 1 "$RDR"/.conf/LIBAUTH)"
		PV1="$(awk '{print $1}' <<< $PV1)"
		if [[ "$PV1" == "false" ]]
		then
			printf "\\e[7;38;5;122m%s\\e[0m\\n" "File ~/"${RDR##*/}"/.conf/LIBAUTH has information regarding the integration of artifacts and libraries into compilations.  The functionality of this option is being enhanced.  To improve this automation see https://github.com/BuildAPKs/buildAPKs/issues and pulls..."
			printf "\\n\\e[2;38;5;28m%s\\e[0m\\n" "Running \$(cat "$RDR"/.conf/LIBAUTH "$RDR"/.conf/LIBAUTH):"
			printf "\\e[1;38;5;29m\\n%s\\e[0m\\n" "$(cat "$RDR"/.conf/LIBAUTH) "$RDR"/.conf/LIBAUTH):"
			CALIBCT="$(( CALIBCT - 3 ))"
			[[ "$CALIBCT" = -1 ]] && VIEWS="showing" || VIEWS="showings"
			printf "\\e[1;38;5;30m\\n%s\\e[0m\\n" "${CALIBCT#-} $VIEWS of file ~/"${RDR##*/}"/.conf/{LIBAUTH,GAUTH} remaining; Continuing..."
		fi
	fi
}

if [[ "$CALIBCT" -lt 4 ]]	# display count is less than 3
then	# print information to terminal
	_MAINCALIB_
fi
# calib.bash EOF
