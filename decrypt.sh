#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

cd -- "$(dirname "$0")"

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <file>" >&2
	exit 1
fi

file="$1"
if [[ ! -f $file ]]; then
	if [[ -f "$file.txt" ]]; then
		file="$file.txt"
	elif [[ -f "encrypted/$file" ]]; then
		file="enrypted/$file"
	elif [[ -f "encrypted/$file.txt" ]]; then
		file="encrypted/$file.txt"
	else
		echo "No such file: $file" >&2
		exit 1
	fi
fi
name=$(basename "${file%.*}")

echo "Decrypting $file..."
gpg --output "decrypted/$name.txt" --decrypt "$file"
