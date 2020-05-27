#!/bin/bash

set -euo pipefail

if command -v amixer &> /dev/null; then
  volume="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $2 }')"
  output="$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{ print $4 }')"
fi

if command -v volnoti &> /dev/null; then
  if [ "${output}" == "off" ]; then
    volnoti-show -m "${volume}"
  else
    volnoti-show "${volume}"
  fi
fi
