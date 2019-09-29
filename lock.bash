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
	exit 217
}

_SLOCKTRPEXIT_() { # run on exit
	local RV="$?"
	_WAKEUNLOCK_
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
 	exit 218 
}

_SLOCKTRPQUIT_() { # Run on quit.
	printf "\\e[?25h\\e[1;7;38;5;0mBuildAPKs %s WARNING:  Quit signal %s received!\\e[0m\\n" "lock.bash" "$?"
 	exit 219 
}

trap '_SLOCKTRPERROR_ $LINENO $BASH_COMMAND $?' ERR 
trap _SLOCKTRPEXIT_ EXIT
trap _SLOCKTRPSIGNAL_ HUP INT TERM 
trap _SLOCKTRPQUIT_ QUIT 

_WAKELOCK_() {
	_PRINTWLA_ 
	am startservice --user 0 -a com.termux.service_wake_lock com.termux/com.termux.app.TermuxService 1>/dev/null
	mkdir -p "$RDR/lock" "$RDR/log"
	touch "$RDR/lock/wake.$$.lock"
	_PRINTDONE_ 
}

_WAKEUNLOCK_() {
	_PRINTWLD_
	rm "$RDR/lock/wake.$$.lock"
	if [[ -n $(find "$RDR/lock" -name "*.lock") ]] # https://unix.stackexchange.com/questions/46541/how-can-i-use-bashs-if-test-and-find-commands-together
	then 
		printf '\033]2;Releasing wake lock: Pending...\007'
		if [[ $(find "$RDR/lock" -type f | wc -l) -gt 1 ]] 
		then
			printf "\\e[1;33mNOT RELEASED.  \\e[1;32mOther lock files are present in ~/%s/lock:\\e[0m" "${RDR##*/}" 
		else
			if [[ -f "$RDR/lock/set.lock" ]] 
			then 
				printf "\\e[1;33mNOT RELEASED.  \\e[1;32m%s\\e[0m" "Found set.lock file!"
			else
				printf "\\e[1;33mNOT RELEASED.  \\e[1;32mAnother lock file is present in ~/%s/lock:\\e[0m" "${RDR##*/}" 
			fi
		fi
		printf "\\n\\n\\e[1;33m"
		ls "$RDR/lock"
		printf "\\n\\e[1;38;5;187mYou can safely delete ~/%s/lock if no other jobs are running.\\e[0m\\n\\n" "${RDR##*/}" 
		_PRINTHELP_
	else 
		am startservice --user 0 -a com.termux.service_wake_unlock com.termux/com.termux.app.TermuxService 1>/dev/null 
		_PRINTDONE_ 
		_PRINTHELP_
	fi
}

_PRINTHELP_() {
	if [[ ! -f "$RDR/lock/set.lock" ]] 
	then 
		printf "\\n\\e[1;38;5;107m%s\\e[1;38;5;109m%s\\e[0m\\n\\n" "To always have wake lock set to on: " "touch ~/${RDR##*/}/lock/set.lock" 
	fi
}

_PRINTDONE_() {
	printf "\\e[1;32mDONE  \\e[0m\\n"
}

_PRINTWLA_() {
	printf "\\n\\e[1;34mActivating wake lock: "'\033]2;Activating wake lock: OK\007'
}

_PRINTWLD_() {
	printf "\\n\\e[1;34mReleasing wake lock: "'\033]2;Releasing wake lock: OK\007'
}

_WAKELOCK_

# lock.bash EOF
