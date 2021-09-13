#!/usr/bin/env bash
# Copyright 2021 (c)  all rights reserved by S D Rausty;  see LICENSE
# https://sdrausty.github.io hosted courtesy https://pages.github.com
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/sh/shlibs/trim.newline.slash.sh
_CLANGDOC_() {
	for NCFILE in $NATEFILES
	do
		printf "%s" "Running command: clang -Os -shared -o ../output/lib/$LIBDIR/${NCFILE//.c}.so $NCFILE:  "
		( clang -Os -shared -o ../output/lib/"$LIBDIR"/"${NCFILE//.c*}".so "$NCFILE" && printf "%s\\n" "DONE" ) || printf "%s\\n" "ERROR FOUND:  Continuing..."
	done
	unset NATEFILES
}

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
ANDROIDMK="$(find . -name "Android.mk")"
if [ -z "$ANDROIDMK" ]
then
	printf "%s\\n" "No 'Android.mk' files were found in directory '$PWD':  Continuing..."
else
	. "$RDR"/scripts/sh/shlibs/trim.newline.slash.sh
	_SLWTTSWN_ "$ANDROIDMK" 
# 	ADMKVARS=( LOCAL_32_BIT_ONLY LOCAL_ADDITIONAL_DEPENDENCIES LOCAL_ARM_MODE LOCAL_CERTIFICATE LOCAL_CFLAGS LOCAL_CLANG LOCAL_CPPFLAGS LOCAL_CXX_STL LOCAL_C_INCLUDES LOCAL_EXPORT_C_INCLUDE_DIRS LOCAL_HAL_STATIC_LIBRARIES LOCAL_JNI_SHARED_LIBRARIES LOCAL_LDFLAGS LOCAL_MODULE LOCAL_MODULE_CLASS LOCAL_MODULE_PATH LOCAL_MODULE_RELATIVE_PATH LOCAL_MODULE_STEM_32 LOCAL_MODULE_STEM_64 LOCAL_MODULE_TAGS LOCAL_MULTILIB LOCAL_PACKAGE_NAME LOCAL_PATH LOCAL_PROTOC_OPTIMIZE_TYPE LOCAL_REQUIRED_MODULES LOCAL_SDK_VERSION LOCAL_SHARED_LIBRARIES LOCAL_SRC_FILES LOCAL_STATIC_LIBRARIES LOCAL_WHOLE_STATIC_LIBRARIES TOP_LOCAL_PATH )
fi
if [ -d jni ]
then
	_LIBDIR_
	cd jni
	NATEFILES="$(find . -type f -name "*.c*")"
	_CLANGDOC_
	cd ..
	printf "%s\\n" "Running command 'ls output/lib/$LIBDIR': $(ls output/lib/$LIBDIR)"
else
	printf "%s\\n" "No 'jni' directory found in directory '$PWD':  Continuing..."
fi
# native.sh EOF
