#!/usr/bin/env bash

if [ "$#" -lt 3 ]; then
	echo "Usage: $0 <site> <branch> <num>"
	exit 1
fi

site=$1
branch=$2
num=$3

artifact="/src/${site}_${num}.tgz"

domain=$(/src/domains.sh "$site" "$branch")

if [ "$domain" != "none" ]; then

	release="/var/www/$domain/releases/$num"
	current="/var/www/$domain/current"

	echo "Extracting $artifact to $release..."
	untarlog=$(sudo -u www-data /src/extract.sh "$artifact" "$release")
	filecount=$(echo "$untarlog" | wc -l)
	echo "Extracted $filecount files"

	echo "Updating link..."
	sudo -u www-data /src/link.sh "$current" "$release"
	echo "$current => $release"

fi

rm "$artifact"
