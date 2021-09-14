#!/usr/bin/env bash
# Copyright 2021 (c)  all rights reserved by S D Rausty;  see LICENSE
# https://sdrausty.github.io hosted courtesy https://pages.github.com
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
_LIBDIR_() {
	UNAMEM="$(uname -m)"
	if [[ "$UNAMEM" = aarch64 ]]
	then
		LIBDIR="arm64-v8a"
	elif [[ "$UNAMEM" = *armv5* ]]
	then
		LIBDIR="armeabi-v5a"
	elif [[ "$UNAMEM" = *armv7* ]]
	then
		LIBDIR="armeabi-v7a"
	elif [[ "$UNAMEM" = *armv8* ]]
	then
		LIBDIR="armeabi-v7a"
	elif [[ "$UNAMEM" = i686 ]]
	then
		LIBDIR="x86"
	elif [[ "$UNAMEM" = x86_64 ]]
	then
		LIBDIR="x86_64"
	else
		printf "%s\\n" "Unknown architecture '$UNAMEM'"
		LIBDIR="$UNAMEM"
		[ -d output/lib/"$LIBDIR" ] || mkdir -p output/lib/"$LIBDIR"
	fi
	[ -d output/lib/"$LIBDIR" ] || mkdir -p output/lib/"$LIBDIR"
}
_LIBDIR_
# libdir.bash EOF
