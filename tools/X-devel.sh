#!/bin/sh

if [ ! "`pgrep lxterminal`" = "" -a ! "`pgrep uxterm`" = "" -a ! "`pgrep leafpad`" = "" ]; then
  exit 0
fi

# lxterminal
nohup lxterminal &
xdotool search --sync --onlyvisible --class lxterminal windowmove 0 336
#DISPLAY=:0 xdotool search --all --onlyvisible --class lxterminal getwindowgeometry

# uxterm
nohup uxterm &
xdotool search --sync --onlyvisible --class uxterm windowmove 0 0
#DISPLAY=:0 xdotool search --all --onlyvisible --class uxterm getwindowgeometry

# leafpad
nohup leafpad &
xdotool search --sync --onlyvisible --class leafpad windowmove 718 0
#DISPLAY=:0 xdotool search --all --onlyvisible --class leafpad getwindowgeometry %3

xdotool search --sync --onlyvisible --class lxterminal windowfocus
