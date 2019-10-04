#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o errtrace
set -o pipefail
# set -o xtrace # Uncomment this line to echo all commands with variables interpolated.

die() { printf '%s\n' "$1" >&2; exit 1; }

cleanup() {
    if [[ $? -ne 0 ]]; then
        echo "Aborting due to errexit on line $LINENO. Exit code $?" >&2
    fi
    # Do whatever cleanup is needed here, e.g.:
    rm -f jsonpart.* whole.json
    if [ "X$file" != "X" ]; then
        rm -f "$file".*
    fi
}

trap cleanup EXIT

usage=$(cat <<EOT

    usage: $0 --named args --go here

EOT
)

while [ $# -gt 0 ]
do
    case "$1" in
        -n|--named) named="$2"; shift;;
        -a|--args) args="$2"; shift;;
        -g|--go) args="$2"; shift;;
        -h|--help) die "$usage";;
        *)  die "$usage";;
    esac
    shift
done
