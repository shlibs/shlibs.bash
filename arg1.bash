#!/usr/bin/env bash
_A1NAHELP_ () {
[[ -n "${1:-}" ]] && { [[ "${1//-}" = [\/]* ]] || [[ "${1//-}" = [?]* ]] || [[ "${1//-}" = [Hh]* ]] ; } && { printf '\e[1;32m%s\n' "Help for '${0##*/}':" && HLFILE="($(grep '##\ ' "$0"))" && printf '\e[0;32m%s\e[1;32m\n%s\n' "$(for HL in "${HLFILE[@]}" ; do cut -d\) -f1 <<< "${HL//###/	}" | cut -f 2 ; done )" "Help for '${0##*/}': DONE" ; exit ; }
}
_A1NA_ () {
[[ -n "${1:-}" ]] && "$2"
}
_A1ZA_ () {
[[ -z "${1:-}" ]] && "$3"
}
# arg1.bash EOF
