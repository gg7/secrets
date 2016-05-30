#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

cd -- "$(dirname "$0")"

echo -n "Enter the website/entity name (e.g. 'codility', without an extension): "
read name

file="decrypted/$name.txt"

if [[ -e "$file" ]]; then
	echo "Error: \"$file\" already exists!" >&2
	exit 1
fi

. util.sh

if [[ $me == "george" ]]; then
	sample_user="paul"
else
	sample_user="george"
fi

echo -n "Writing template to \"$file\"..."
cat <<-EOF > "$file"
	ACL: $me $sample_user
	--------------------------------------------------------------------------------
	$name: {{{
	  user: CHANGE_ME
	  pass: CHANGE_ME
	}}}

	vim: set et sw=2 :
EOF
echo " done"

echo "Spawning editor..."
${EDITOR:-vim} "$file"

./encrypt.sh "$file"

echo "Now commit and push!"
