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
	elif [[ -f "decrypted/$file" ]]; then
		file="decrypted/$file"
	elif [[ -f "decrypted/$file.txt" ]]; then
		file="decrypted/$file.txt"
	else
		echo "No such file: $file" >&2
		exit 1
	fi
fi
name=$(basename "${file%.*}")

acl=$(head -n 1 "$file" | grep -Po 'ACL:.*$' | sed 's/^ACL://' || true)
if [[ -z $acl ]]; then
	echo "Couldn't extract ACL" >&2
	exit 1
fi

echo "name: $name, file: $file, acl: $acl"

. util.sh

if [[ " ${acl[@]} " != *" $me "* ]] && [[ " ${acl[@]} " != *" $me_emailified "* ]]; then
	echo "WARN: Adding yourself to ACL"
	acl="$me_emailified $acl"
fi

recipients=( )
for person in $acl; do
	person=$(emailify "$person")

	if ! gpg --list-keys "$person" > /dev/null; then
		echo "$person: Key not imported; attempting import"
		gpg --import "pubkeys/${person}.asc"
	fi

	echo "$person: OK"
	recipients+=( "--recipient" "$person" )
done

echo "Encrypting $file..."
gpg --encrypt --sign --trust-model always --output "encrypted/${name}.gpg" "${recipients[@]}" "$file"

echo -n "Shred decrypted file? [y/N]"
read ans
if [[ $ans == "y" ]]; then
	shred --remove "decrypted/$name.txt"
fi
