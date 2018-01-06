#!/bin/sh
if [ "$1" = "" ]; then
  echo "$0 [display|0] \"value\""
else
A=0
if [ ! "$2" = "" ]; then
  A=$1
  shift
fi
printf "$@" | xsel --display :$A -p -i
printf "$@" | xsel --display :$A -s -i
printf "$@" | xsel --display :$A -b -i
fi
