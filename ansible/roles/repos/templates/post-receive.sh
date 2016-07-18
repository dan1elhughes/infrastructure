#!/bin/bash

src='/src/{{ item.url }}'
dir="/var/www/{{ item.url }}"

while read oldrev newrev ref
do
	if [[ $ref =~ .*/{{ item.branch | default('master') }}$ ]];
	then
		echo "Commit on {{ item.branch | default('master') }} received."
		sudo -u www-data /src/deploy.sh "$src" "{{ item.branch | default('master') }}" "$dir"
		exit 0
	else
		echo "$ref received, but only the {{ item.branch | default('master') }} branch is deployed."
		exit 0
	fi
done
