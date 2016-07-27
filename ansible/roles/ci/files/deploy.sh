#!/usr/bin/env bash

if [ "$#" -lt 3 ]; then
	echo "Usage: $0 <site> <branch> <num>"
	exit 1
fi

site=$1
branch=$2
num=$3

artifact="/src/${site}_${num}.tgz"
release="/src/var/www/$site-$branch/releases/$num"
current="/src/var/www/$site-$branch/current"
# shared="/var/www/$site-$branch/shared"

echo "Extracting $artifact to $release..."
mkdir -p "$release"
untarlog="$(tar -xzvf $artifact -C $release --strip-components 1 --exclude='.git*')"
filecount=$(echo "$untarlog" | wc -l)
echo "Extracted $filecount files"

echo "Updating link..."
[ -L "$current" ] && rm "$current"
ln -sf "$release" "$current"
echo "$current => $release"

#rm "$artifact"
