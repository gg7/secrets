#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

cd -- "$(dirname "$0")"

emailify() {
	if [[ ! $1 =~ @ ]]; then
		echo "$1@gmail.com"
	else
		echo "$1"
	fi
}

if [[ -f "whoami" ]]; then
	me=$(cat whoami)
	me_emailified=$(emailify "$(cat whoami)")
else
	me=$(whoami)
	me_emailified=$(emailify "$(whoami)")
fi
