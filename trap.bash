#!/bin/env bash 
# Copyright 2019 (c) all rights reserved ; See LICENSE 
# by S D Rausty https://sdrausty.github.io
#####################################################################
set -Eeuo pipefail
shopt -s nullglob globstar
export RDR="$HOME/buildAPKs"
. "$RDR"/scripts/bash/shlibs/lock.bash 
_SBTRPERROR_() { # run on script error
	local RV="$?"
	if [[ "$RV" == 1 ]]  
	then 
		printf "\\n\\e[1;48;5;130mERROR return value %s received by %s %s:  Exiting due to error signal %s near or at line number %s by \`%s\` with return value %s.,.\\e[0m\\n" "$RV" "$TPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
		exit $TERROR
	else
		printf "\\n\\e[1;48;5;138mBuildAPKs %s %s  ERROR:  Generated script error signal %s near or at line number %s by \`%s\` with return value %s\\e.,.[0m\\n" "$TPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
		exit $TERROR
	fi
	_WAKEUNLOCK_
	printf "\\e[?25h"
	set +Eeuo pipefail 
 	exit $TERROR
}

_SBTRPEXIT_() { # run on exit
	local RV="$?"
	if [[ "$RV" != 0 ]]  
	then 
		printf "%s\\n" "Signal $RV received by $TPARENT trap.bash:  Exiting..." 
	else
		_WAKEUNLOCK_
	fi
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
	exit 0
}

_SBTRPSIGNAL_() { # run on signal
	local RV="$?"
	printf "\\n\\e[1;48;5;138mBuildAPKs %s trap.bash WARNING:  Signal %s received near or at line number %s by \`%s\` with return value %s:  Exiting...\\e[0m\\n" "$TPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
	_WAKEUNLOCK_
	printf "\\e[?25h"
	set +Eeuo pipefail 
 	exit $TSIGNAL
}

_SBTRPQUIT_() { # run on quit
	local RV="$?"
	printf "\\n\\e[1;48;5;138mBuildAPKs %s %s WARNING:  Quit signal %s received near or at line number %s by \`%s\` with return value %s:  Exiting...\\e[0m\\n" "$TPARENT" "${0##*/}" "${3:-SIGNAL}" "${1:-LINENO}" "${2:-BASH_COMMAND}" "$RV"
	_WAKEUNLOCK_
	printf "\\e[?25h\\e[0m"
	set +Eeuo pipefail 
 	exit $TQUIT
}

trap '_SBTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SBTRPEXIT_ EXIT
trap '_SBTRPSIGNAL_ $LINENO $BASH_COMMAND $?' HUP INT TERM
trap '_SBTRPQUIT_ $LINENO $BASH_COMMAND $?' QUIT 
TQUIT="$1"
TSIGNAL="$2"
TERROR="$3"
TPARENT="${4:-undefined}"
# trap.bash EOF
