#!/usr/bin/env bash

keyfile='/root/.ssh/authorized_keys'

[ -s "$keyfile" ] || curl -sSL https://github.com/dan1elhughes.keys > "$keyfile"
