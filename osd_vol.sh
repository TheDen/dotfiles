#!/bin/bash

# Shows OSD for amixer
# Dependencies in $PATH: amixer volnoti
# If they don't exist, the script will skip execution

set -euo pipefail

if command -v amixer &> /dev/null; then
  volume="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')"
  output="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')"
fi

if command -v volnoti &> /dev/null; then
  if [ "${output}" == "off" ]; then
    volnoti-show -m
  else
    if [ "${volume//%/}" -gt "100" ]; then
      volume="100%"
    fi
    volnoti-show "${volume}"
  fi
fi
