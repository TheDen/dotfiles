#!/bin/bash

BASEDIR=$(dirname "$0")
BASENAME=$(basename $0)

(cd "$BASEDIR" || exit

diffcmd=$(command -v colordiff)

if [ ! -n "$(command -v colordiff)" ]; then
  diffcmd="diff"
fi

for i in $(git ls-files | grep -v ".git\|$BASENAME"); do
  echo $i
  localfile=$(find ~/ -iname "$i" -print -quit 2> /dev/null)
  if [ -n "$localfile" ] ; then
    DIFF="$($diffcmd "$i" "$(find ~/ -iname "$i" -print -quit 2> /dev/null)")"
    if [ -n "$DIFF" ] ; then
      echo "====================="
      echo "$i"
      echo "$DIFF"
      echo "====================="
    fi
  fi
  localfile=""
  DIFF=""
done)
