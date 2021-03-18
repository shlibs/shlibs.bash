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
printf "\\n\\e[1;1;38;5;108m%s\\n%s\\e[0m\\n\\n" "Build APKs (Android Package Kits) with scripts in ~/${RDR##*/}/scripts/{bash,sh,zsh}/build/:" "$BBSL"
mkdir -p "$TMPDIR/fa$$"
printf "\\e[1;1;38;5;118m%s\\e[0m\\n\\n" "Calculating for ~/${RDR##*/}/.  This may take a while;  Please be patient..."
find "$RDR/sources/" -path "$RDR/sources/github/*" -prune -o -type f -name AndroidManifest.xml > "$TMPDIR/fa$$/possible.total"
find "$RDR/sources/" -path "$RDR/sources/github/*" -prune -o -type f -name "*.apk" > "$TMPDIR/fa$$/built.total"
find "$JDR" -type f -name AndroidManifest.xml > "$TMPDIR/fa$$/possible" ||:
find "$JDR" -type f -name "*.apk" > "$TMPDIR/fa$$/built" ||:
cd "$TMPDIR/fa$$"
printf "\\e[1;1;38;5;119m%s\\e[0m\\n\\n" "The total increases as modules are added;  The build scripts add modules and create APKs on device.  Results for ~/${RDR##*/}/sources/:"
wc -l possible.total built.total | sed -n 1,2p # https://www.cyberciti.biz/faq/unix-linux-show-first-10-20-lines-of-file/
printf "\\n\\e[1;1;38;5;120m%s\\e[0m\\n\\n" "Results for ~/${RDR##*/}/sources/$JID/:"
wc -l possible built | sed -n 1,2p
# if these directories are writable
if [[ -w "/storage/emulated/0/Download/builtAPKs/$JID.$DAY" ]] || [[ -w "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY" ]]
then	# count the built APKs
	if [[ -w "/storage/emulated/0/Download/builtAPKs/$JID.$DAY" ]]
	then
		printf "\\n\\e[1;1;38;5;121m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for Download/builtAPKs/:" "$(find /storage/emulated/0/Download/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in Download/builtAPKs/" "$(( $(ls -Al "/storage/emulated/0/Download/builtAPKs/$JID.$DAY"/ | wc -l) - 1 ))" " deposited in Download/builtAPKs/$JID.$DAY/"
	fi
	if [[ -w "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY" ]]
	then
		printf "\\n\\e[1;1;38;5;121m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for Download/builtAPKs/:" "$(find /storage/emulated/legacy/Download/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in Download/builtAPKs/" "$(( $(ls -Al "/storage/emulated/legacy/Download/builtAPKs/$JID.$DAY"/ | wc -l) - 1 ))" " deposited in Download/builtAPKs/$JID.$DAY/"
	fi
else	# count the built APKs
	printf "\\n\\e[1;1;38;5;122m%s\\e[0m\\n\\n	%s%s\\n	%s%s\\n" "Results for ~/${RDR##*/}/var/cache/builtAPKs/:" "$(find "$RDR"/var/cache/builtAPKs/ -type f -name "*.apk" | wc -l)" " deposited in ~/${RDR##*/}/var/cache/builtAPKs/" "$(( $(ls -Al "$RDR/var/cache/builtAPKs/$JID.$DAY" | wc -l) - 1 ))" " deposited in ~/${RDR##*/}/var/cache/builtAPKs/$JID.$DAY/"
fi
rm -rf "$TMPDIR/fa$$"
# tots.bash EOF
