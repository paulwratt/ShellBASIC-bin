#!/bin/sh
A=0
if [ ! "$1" = "" ]; then
  A=$1
fi
xsel -o --display :$A
