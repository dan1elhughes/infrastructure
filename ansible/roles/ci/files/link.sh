#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
	echo "Usage: $0 <current> <release>"
	exit 1
fi

current=$1
release=$2

[ -L "$current" ] && rm "$current"
ln -sf "$release" "$current"
ln -sf "$(readlink -f $current/../../.env)" "$current/.env"
