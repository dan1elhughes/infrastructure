#!/usr/bin/env bash

if [ "$#" -lt 3 ]; then
	echo "Usage: $0 <src> <branch> <www>"
	exit 1
fi

date=`date +%Y-%m-%d-%H:%M:%S`

src=$1
branch=$2
www="$3/releases/$date"

mkdir -p "$www"

echo "Deploying $branch to $www..."

git --work-tree="$www" --git-dir="$src" checkout -f "$branch"

if [ -f "$www/.build" ]; then
	echo "Executing build..."
	cd "$www"
	while read step; do
		echo ""
		echo "[Executing : $step]"
		echo ""
		eval $step
		result=$?
		if [ $result != 0 ]; then
			printf "Error [%d] while executing step: '$step'" $result
			exit 1
 		fi
	done <"$www/.build"
fi

echo "Updating link..."

[ -L "$3/current" ] && rm "$3/current"
ln -sf "$www" "$3/current"

echo "$www => $3/current"
