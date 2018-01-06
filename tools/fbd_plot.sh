#!/bin/sh
# ShellBASIC-bin:helper

if [ "$1" = "" -o "$1" = "--help" ]; then
  echo "Frame Buffer Direct - plot"
  echo "           requires: 'setfb' & /dev/fb0"
  echo " plots an R,G,B decimal color at X,Y in"
  echo " a specified pixel format."
  echo ""
  echo "usage:"
#       123456789012345678901234567890123456789
  echo "  fbd_plot X Y R G B A [fbdev]"
  echo "options:"
  echo "  X         decimal across screen"
  echo "  Y         decimal down screen"
  echo "  R         red channel decimal value"
  echo "  G         green channel decimal value"
  echo "  B         blue channel decimal value"
  echo "  A         alpha channel decimal value"
  echo "  fbdev     default is /dev/fb0"
  exit 0
fi

FB=/dev/fb0
if [ ! "$7" = "" ]; then
  if [ -c $7 ]; then
    FB=$7
  else
    echo "Error: not a character device: $7"
    exit 1
  fi
fi
if [ "$6" = "" ]; then
  echo "Error: missing alpha chanel"
  exit 3
fi

PF=`fbset | grep "rgb" | cut -c 5-`
#LL=`fbset -i | grep "LineLength" | cut -c 19-`
PW=`fbset | grep geo | xargs | cut -d \  -f 2`
PO=$(( ( $PW * $2 ) + $1 ))
if [ "$PF" = "rgba 8/16,8/8,8/0,8/24" ]; then
  printf "$(printf '\\%o\\%o\\%o\\%o' $5 $4 $3 $6)" | dd status=none bs=4 seek=$PO > $FB
elif [ "$PF" = "rgb 8/16,8/8,8/0" ]; then
  printf "$(printf '\\%o\\%o\\%o' $5 $4 $3)" | dd status=none bs=3 seek=$PO > $FB
else
  echo "please add a pixel format for: $PF"
  exit 2
fi
exit 0

