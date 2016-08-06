#!/usr/bin/env bash

if [ "$#" -lt 2 ]; then
	echo "Usage: $0 <artifact> <directory>"
	exit 1
fi

artifact=$1
directory=$2

mkdir -p "$directory"

tar -xzvf $artifact -C $directory --strip-components 1 --exclude='.git*'
