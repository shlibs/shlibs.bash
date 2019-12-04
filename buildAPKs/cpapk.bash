#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved by S D Rausty; see LICENCE 
################################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/init/atrap.bash 237 238 239 "${0##*/} cpapk.bash" 
_CPAPK_ () {
if [[ -w "/storage/emulated/0/" ]] ||  [[ -w "/storage/emulated/legacy/" ]]  
then
	if [[ -w "/storage/emulated/0/" ]] 
	then
		if [[ ! -d "/storage/emulated/0/Download/builtAPKs/$JID.$DAY" ]]
		then
			mkdir -p "/storage/emulated/0/Download/builtAPKs/$JID.$DAY"
		fi
		cp "$PKGNAM.apk" "/storage/emulated/0/Download/builtAPKs/$JID.$DAY/$PKGNAME.apk"
	fi
	if [[ -w "/storage/emulated/legacy/" ]]  
	then
		if [[ ! -d "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY" ]]
		then
			mkdir -p "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY"
		fi
		cp "$PKGNAM.apk" "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY/$PKGNAME.apk"
	fi
	printf "\\e[1;38;5;115mCopied %s to Download/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
	printf "\\e[1;38;5;149mThe APK %s file can be installed from Download/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
else
	if [[ ! -d "$RDR/var/cache/builtAPKs/$JID.$DAY" ]]
	then
		mkdir -p "$RDR/var/cache/builtAPKs/$JID.$DAY"
	fi
	cp "$PKGNAM.apk" "$RDR/var/cache/builtAPKs/$JID.$DAY/$PKGNAME.apk"
	printf "\\e[1;38;5;120mCopied %s to $RDR/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
	printf "\\e[1;38;5;154mThe APK %s file can be installed from ~/${RDR:33}/var/cache/builtAPKs/%s/%s.apk\\n" "$PKGNAM.apk" "$JID.$DAY" "$PKGNAME"
fi
printf "\\e[?25h\\e[1;7;38;5;34mShare %s everwhere%s!\\e[0m\\n" "https://wiki.termux.com/wiki/Development" "🌎🌍🌏🌐"
}
# apk.bash EOF
