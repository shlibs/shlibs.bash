#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved
# by buildAPKs https://buildapks.github.io
# Copy APK file.
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
_COPYAPK_ () {
	[ ! -e /storage/emulated/0/Android/data/com.termux/builtAPKs ] && mkdir -p /storage/emulated/0/Android/data/com.termux/builtAPKs
	[ ! -e /storage/emulated/0/Android/media/com.termux/builtAPKs ] && mkdir -p /storage/emulated/0/Android/media/com.termux/builtAPKs
	# if directories are writable
	if [ -w "/storage/emulated/0/" ] || [ -w "/storage/emulated/legacy/" ]
	then	# check if this directory is writable
		if [ -w "/storage/emulated/0/" ]
		then	# create this directory if it does not exist
			[ ! -d "/storage/emulated/0/Download/builtAPKs/$JID.$DAY" ] && mkdir -p "/storage/emulated/0/Download/builtAPKs/$JID.$DAY"
			# copy APK file to destination directory
			cp "$PKGNAME.apk" "/storage/emulated/0/Download/builtAPKs/$JID.$DAY/$PKGNAME.apk"
		# else check if this directory is writable
		elif [ -w "/storage/emulated/legacy/" ]
		then	# create this directory if it does not exist
			[ ! -d "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY" ] && mkdir -p "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY"
			# copy APK file to destination directory
			cp "$PKGNAME.apk" "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY/$PKGNAME.apk"
		fi
		# print copied APK file name and destination
		printf "\\e[1;38;5;115mCopied %s to Download/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
		printf "\\e[1;38;5;149mThe APK %s file can be installed from Download/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
	elif [ -e /storage/emulated/0/Android/media/com.termux/builtAPKs ]
	then
		[ ! -d "/storage/emulated/0/Android/media/com.termux/builtAPKs/$JID.$DAY" ] && mkdir -p "/storage/emulated/0/Android/media/com.termux/builtAPKs/$JID.$DAY"
		cp "$PKGNAME.apk" "/storage/emulated/0/Android/media/com.termux/builtAPKs/$JID.$DAY/$PKGNAME.apk"
		printf "\\e[1;38;5;120mCopied %s to /storage/emulated/0/Android/media/com.termux/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
		printf "\\e[1;38;5;154mThe APK %s file can be installed from /storage/emulated/0/Android/media/com.termux/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
	elif [ -e /storage/emulated/0/Android/data/com.termux/builtAPKs ]
	then
		[ ! -d "/storage/emulated/0/Android/data/com.termux/builtAPKs/$JID.$DAY" ] && mkdir -p "/storage/emulated/0/Android/data/com.termux/builtAPKs/$JID.$DAY"
		cp "$PKGNAME.apk" "/storage/emulated/0/Android/data/com.termux/builtAPKs/$JID.$DAY/$PKGNAME.apk"
		printf "\\e[1;38;5;120mCopied %s to /storage/emulated/0/Android/data/com.termux/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
		printf "\\e[1;38;5;154mThe APK %s file can be installed from ~/${RDR##*/}/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
	else	# create this directory if it does not exist
		[ ! -d "$RDR/var/cache/builtAPKs/$JID.$DAY" ] && mkdir -p "$RDR/var/cache/builtAPKs/$JID.$DAY"
		# copy APK file to destination directory
		cp "$PKGNAME.apk" "$RDR/var/cache/builtAPKs/$JID.$DAY/$PKGNAME.apk"
		# print copied APK file name and destination
		printf "\\e[1;38;5;120mCopied %s to $RDR/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
		printf "\\e[1;38;5;154mThe APK %s file can be installed from ~/${RDR##*/}/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAME.apk" "$JID.$DAY" "$PKGNAME"
	fi
}
# copy.apk.bash EOF
