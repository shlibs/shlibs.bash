#!/bin/env bash 
# Copyright 2017-2019 (c) all rights reserved 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar

_SLOCKTRPERROR_() { # Run on script error.
	local RV="$?"
	echo "$RV"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs lock.bash ERROR:  Generated script error %s near or at line number %s by \`%s\`!\\e[0m\\n" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}"
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 5
}

_SLOCKTRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		echo "Signal $RV received by lock.bash!"  
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SLOCKTRPSIGNAL_() { # Run on signal.
	local RV="$?"
	printf "\\e[?25h\\n\\e[1;48;5;138mBuildAPKs lock.bash WARNING:  Signal %s received!\\e[0m\\n" "$RV" 
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
 	exit 4 
}

_SLOCKTRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "lock.bash" "$?"
	printf "\\e[?25h\\e[0m"
 	exit 3 
}

trap '_SLOCKTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SLOCKTRPEXIT_ EXIT
trap _SLOCKTRPSIGNAL_ HUP INT TERM 
trap _SLOCKTRPQUIT_ QUIT 
# lock.bash EOF
