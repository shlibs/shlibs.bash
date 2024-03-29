#!/usr/bin/env bash
# Copyright 2017-2021 (c) all rights reserved ; See LICENSE
# by S D Rausty https://sdrausty.github.io
# compares totals: build attempts with deposited Android Package Kits
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
. "$RDR"/scripts/bash/shlibs/trap.bash 177 178 179 "${0##*/} tots.bash"
. "$RDR"/scripts/bash/shlibs/buildAPKs/calib.bash
BBSL="$(find "$RDR/scripts/" -name build -exec ls {} \;)"
printf "\\n\\e[1;1;38;5;108m%s\\n%s\\e[0m\\n\\n" "Build APKs (Android Package Kits) with scripts in ~/${RDR##*/}/scripts/{bash,ksh,sh,zsh}/build/:" "$BBSL"
. "$RDR/scripts/bash/shlibs/buildAPKs/bnchn.bash" bch.gt
mkdir -p "$TMPDIR/fa$$"
printf "\\e[1;1;38;5;118m%s\\e[0m\\n\\n" "Calculating for ~/${RDR##*/}/.  This may take a while;  Please be patient..."
find "$RDR/sources/" -path "$RDR/sources/github/*" -prune -o -type f -name AndroidManifest.xml > "$TMPDIR/fa$$/possible.total"
find "$RDR/sources/" -path "$RDR/sources/github/*" -prune -o -type f -name "*.apk" > "$TMPDIR/fa$$/built.total"
find "$JDR" -type f -name AndroidManifest.xml > "$TMPDIR/fa$$/possible" ||:
find "$JDR" -type f -name "*.apk" > "$TMPDIR/fa$$/built" ||:
cd "$TMPDIR/fa$$"
printf "\\e[1;1;38;5;119m%s\\e[0m\\n\\n" "The total increases as modules and projects are added;  The build scripts add modules and projects and create APKs on device.  Results for ~/${RDR##*/}/sources/:"
wc -l possible.total built.total | sed -n 1,2p # https://www.cyberciti.biz/faq/unix-linux-show-first-10-20-lines-of-file/
printf "\\n\\e[1;1;38;5;120m%s\\e[0m\\n\\n" "Results for ~/${RDR##*/}/sources/$JID/:"
wc -l possible built | sed -n 1,2p
# count the built APKs
if [ -w "/storage/emulated/0/Download/builtAPKs/$JID.$DAY/" ]
then
	printf "\\n\\e[1;1;38;5;121m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for Download/builtAPKs/:" "$(find /storage/emulated/0/Download/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in Download/builtAPKs/" "$(( $(ls -Al "/storage/emulated/0/Download/builtAPKs/$JID.$DAY/" | wc -l) - 1 ))" " deposited in Download/builtAPKs/$JID.$DAY/"
elif [ -w "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY/" ]
then
	printf "\\n\\e[1;1;38;5;121m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for Download/builtAPKs/:" "$(find /storage/emulated/legacy/Download/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in Download/builtAPKs/" "$(( $(ls -Al "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY/" | wc -l) - 1 ))" " deposited in Download/builtAPKs/$JID.$DAY/"
elif [ -d "/storage/emulated/0/Android/media/com.termux/builtAPKs/$JID.$DAY/" ]
then
	printf "\\n\\e[1;1;38;5;121m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for /storage/emulated/0/Android/media/com.termux/builtAPKs/:" "$(find /storage/emulated/0/Android/media/com.termux/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in /storage/emulated/0/Android/media/com.termux/builtAPKs/" "$(( $(ls -Al "/storage/emulated/0/Android/media/com.termux/builtAPKs/$JID.$DAY/" | wc -l) - 1 ))" " deposited in /storage/emulated/0/Android/media/com.termux/builtAPKs/$JID.$DAY/"
elif [ -d "/storage/emulated/0/Android/data/com.termux/builtAPKs/$JID.$DAY/" ]
then
	printf "\\n\\e[1;1;38;5;121m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for /storage/emulated/0/Android/data/com.termux/builtAPKs/:" "$(find /storage/emulated/0/Android/data/com.termux/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in /storage/emulated/0/Android/data/com.termux/builtAPKs/" "$(( $(ls -Al "/storage/emulated/0/Android/data/com.termux/builtAPKs/$JID.$DAY/" | wc -l) - 1 ))" " deposited in /storage/emulated/0/Android/data/com.termux/builtAPKs/$JID.$DAY/"
elif [ -d "$RDR/var/cache/builtAPKs/$JID.$DAY/" ]
then
	printf "\\n\\e[1;1;38;5;122m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for ~/${RDR##*/}/var/cache/builtAPKs/:" "$(find "$RDR"/var/cache/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in ~/${RDR##*/}/var/cache/builtAPKs/" "$(( $(ls -Al "$RDR/var/cache/builtAPKs/$JID.$DAY/" | wc -l) - 1 ))" " deposited in ~/${RDR##*/}/var/cache/builtAPKs/$JID.$DAY/"
else
	printf "\\n\\e[1;1;38;5;124m%s\\e[1;32m%s\\e[0m\\n" "Could not tally all the results for builtAPKs:  " "Continuing..."
fi
rm -rf "$TMPDIR/fa$$"
printf '\n%s\n\n' "Please share information about new projects found at https://github.com/BuildAPKs/db.BuildAPKs/issues and https://github.com/BuildAPKs/db.BuildAPKs/pulls in order to assist in developing this project."
# tots.bash EOF
