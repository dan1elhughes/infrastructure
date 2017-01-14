#!/usr/bin/env bash
# {{ ansible_managed }}

if [ "$#" -lt 2 ]; then
	echo "Usage: $0 <site> <branch>"
	exit 1
fi

site=$1
branch=$2

{% for site in sites %}

if [ "$site" == "{{ site.url }}" ] && [ "$branch" == "{{ site.branch }}" ]; then
	{% if site.branch == 'master' -%}
	echo '{{ site.url }}'; exit 0
	{% else -%}
	echo '{{ site.url }}.{{ site.branch }}.xes.io'; exit 0
	{% endif %}
fi

{% endfor %}

echo 'none'
