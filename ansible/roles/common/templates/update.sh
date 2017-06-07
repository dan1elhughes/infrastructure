#!/usr/bin/env bash
# {{ ansible_managed }}

sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoremove && sudo apt-get clean
