#!/bin/sh
# fbd_info.sh - created with 'mkshcmd'
EE=0
if [ "$1" = "--help" -o "$1" = "" ]; then
  echo "Frame Buffer Direct - info"
  echo "                        requires: fbset"
  echo " processes the results of 'fbset -i' so"
  echo " that switches  can be passed  to other"
  echo " FBD commands. Output follows the order"
  echo " of the command line options."
  echo ""
  echo "options:"
  echo "  x|y		surface dimensions"
  echo "  width 	drawing dimensions"
  echo "  height	drawing dimensions"
  echo "  bitsperpixel	color bits per pixel"
  echo "  linelength	8 bit bytes per line"
  echo "  rgbformat	color format"
  echo "  MODE		name of mode output"
  echo "  POINTER	address of framebuffer"
  echo "  SIZE		surface size in bytes"
  echo "  TYPEOFCOLOR	type of pixel format"
  echo "  NAMEOFCOLOR	name of color mode"
  echo "  packed	first letter of option"	
  echo "  /dev/fb?	0-9 framebuffer device"
  echo ""
  echo "NOTE: drawing dimensions are not always"
  echo "      equal to surface dimenions, so"
  echo "      don't presume they are, however,"
  echo "      they are most often the same".
  echo "        geometry x y width height bpp"
  echo ""
  echo "error: 255 = 'fbset' not found"
  echo "       128 = not a character device"
  echo "        64 = unknown pixel format"
  echo "         n = unknown option"
  echo ""
  echo "usage: fbd_info.sh [option option ..]"
  echo "       fbd_info.sh p [xywhblrMPSTN] [?]"
  exit 0
fi
if [ ! -x "`which fbset`" ]; then
  echo "Error: not found: 'fbset'"
  exit 255
fi
FBDEV=""; FB=""
for i in $@; do
  if echo "$i" | grep "/dev/" > /dev/null ; then
    FBDEV="$i"
  else
    if echo "0123456789" | grep "$i" > /dev/null ; then
      FBDEV="/dev/fb$i"
    fi
  fi
done
if [ ! "$FBDEV" = "" ];then
  if [ -c $FBDEV ]; then
    FB="-fb $FBDEV"
  else
    echo "Error: not a character device: '$FBDEV'"
    exit 128
  fi
fi
OPTS="$@"
if [ "$1" = "p" -o "$1" = "packed" ]; then
  OPTS="`echo $2 | sed 's/\([a-zA-Z]\{1\}\)/\1 /g'`"
fi
J=0
for i in $OPTS; do
  J=$(( $J + 1 ))
  E=$J
  if [ "$i" = "x" ]; then fbset $FB | grep geo | xargs | cut -d \  -f 2 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "y" ]; then fbset $FB | grep geo | xargs | cut -d \  -f 3 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "w" -o "$i" = "width" ]; then fbset $FB | grep geo | xargs | cut -d \  -f 4 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "h" -o "$i" = "height" ]; then fbset $FB | grep geo | xargs | cut -d \  -f 5 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "b" -o "$i" = "bpp" -o "$i" = "bitsperpixel" ]; then fbset $FB | grep geo | xargs | cut -d \  -f 6 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "M" -o "$i" = "MODE" ]; then fbset $FB | grep "^mode" | cut -d \" -f 2 | sed 's/\ \?\([\ 0-9a-zA-Z]\+\)/\\"\1\\"/g' | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "r" -o "$i" = "rgb" -o "$i" = "rgba" -o "$i" = "rgbformat" -o "$i" = "rgbaformat" -o "$i" = "format" ]; then
    URGBA=""
    RGBA="`fbset $FB | grep rgb | xargs | cut -d \  -f 2`"
    if [ "$RGBA" = "8/16,8/8,8/0,8/24" ]; then URGBA="BGRA8888" ; fi
    if [ "$URGBA" = "" ]; then
      printf "$RGBA "
      E=64
    else
      printf "$URGBA "
      E=0
    fi
  fi
  if [ "$i" = "l" -o "$i" = "ll" -o "$i" = "linelength" -o "$i" = "length" ]; then
    fbset -i $FB | grep LineLength | cut -d \: -f 2 | xargs printf "%s " ; E=0
  fi
  if [ "$i" = "A" -o "$i" = "ADDRESS" ]; then fbset -i $FB | grep Address | cut -d \: -f 2 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "P" -o "$i" = "POINTER" ]; then fbset -i $FB | grep Address | cut -d \: -f 2 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "S" -o "$i" = "SIZE" ]; then fbset -i $FB | grep Size | cut -d \: -f 2 | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "T" -o "$i" = "TYPE" -o "$i" = "TYPEOFCOLOR" ]; then fbset -i $FB | grep Type | cut -d \: -f 2 | sed 's/\ \?\([\ 0-9a-zA-Z]\+\)/\\"\1\\"/g' | xargs printf "%s " ; E=0 ; fi
  if [ "$i" = "N" -o "$i" = "NAME" -o "$i" = "NAMEOFCOLOR" ]; then fbset -i $FB | grep Visual | cut -d \: -f 2 | sed 's/\ \?\([\ 0-9a-zA-Z]\+\)/\\"\1\\"/g' | xargs printf "%s "  ; E=0 ; fi
  if [ $E -gt 0 ]; then EE=$E ; fi
done
printf "\n"
unset E
unset J
unset OPTS
unset FB
unset FBDEV
#echo $EE
exit $EE

