#!/usr/bin/env bash
# Copyright 2021 (c)  all rights reserved by S D Rausty;  see LICENSE
# https://sdrausty.github.io hosted courtesy https://pages.github.com
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
_CLANGDOC_() {
	for NCFILE in $NATEFILES
	do
		NATEFILE="${NCFILE//.\/}"
		NATEFILE="${NATEFILE//.c*}"
		printf "%s" "Running command: clang -Os -shared -o ../output/lib/$LIBDIR/$NATEFILE.so $NCFILE:  "
		( clang -Os -shared -o ../output/lib/"$LIBDIR"/"$NATEFILE".so "$NCFILE" && printf "%s\\n" "DONE" ) || printf "%s\\n" "ERROR FOUND: Continuing..."
	done
	unset NATEFILES
}

_JNIDIR_() {
	if [ -d jni ]
	then
		cd jni
		NATEFILES="$(find . -type f -name "*.c*")"
		_CLANGDOC_
		cd ..
		printf "%s\\n" "Running command 'ls output/lib/$LIBDIR': $(ls output/lib/$LIBDIR)"
	else
	printf "%s\\n" "No 'jni' directory found: Continuing..."
fi
}
. "$RDR"/scripts/bash/shlibs/libdir.sh
ANDROIDMK="$(find . -name "Android.mk")"
if [ -z "$ANDROIDMK" ]
then
	printf "%s\\n" "No 'Android.mk' files were found: Continuing..."
	_JNIDIR_
else
	printf "%s\\n" "File 'Android.mk' found: Continuing..."
	. "$RDR"/scripts/sh/shlibs/trim.newline.slash.sh
	LOCAL_SRC_FILES="$(_SLWTTSWN_ "$ANDROIDMK" | grep LOCAL_SRC_FILES | cut -f2 -d "=" | cut -f2 -d " " | sed 's/$(call//' | sed 's/optional //' | paste -s -d ' ' )"
	LOCAL_MODULE="$(_SLWTTSWN_ "$ANDROIDMK" | grep LOCAL_MODULE | cut -f2 -d "=" | cut -f2 -d " " | sed 's/$(call//' | sed 's/optional //' | paste -s -d ' ' )"
	printf "%s" "Running command: clang -Os -shared -o ../output/lib/$LIBDIR/$LOCAL_MODULE.so $LOCAL_SRC_FILES:  "
	( clang -Os -shared -o ../output/lib/"$LIBDIR/$LOCAL_MODULE".so "$LOCAL_SRC_FILES" && printf "%s\\n" "DONE" ) || ( printf "%s\\n" "ERROR FOUND: Continuing..." && _JNIDIR_ )
fi
# native.bash EOF
