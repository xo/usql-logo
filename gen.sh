#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pushd $SRC &> /dev/null

LOGO=usql
ICON=icon
OPTIMIZED=${LOGO}-optimized
MINIMIZED=${LOGO}-minimized
WIDTH=220
HEIGHT=80

# optimize
svgo \
  --pretty \
  --indent=2 \
  --precision=4 \
  --output=$OPTIMIZED.svg \
  ${LOGO}.svg

# remove width + height attributes and convert to viewBox
#perl -pi -e 's/ (width|height)="100%"//g' $OPTIMIZED.svg
#perl -pi -e 's/width="90" height="90"/viewBox="0 0 90 90"/' $OPTIMIZED.svg

# minimize
svgo \
  --precision=4 \
  --output=$MINIMIZED.svg \
  $OPTIMIZED.svg

# generate png
inkscape \
  --export-area-page \
  --export-width=$((WIDTH*8)) \
  --export-height=$((HEIGHT*8)) \
  --export-type=png \
  -o $LOGO.png \
  $LOGO.svg

inkscape \
  --export-area-page \
  --export-width=$((WIDTH/2)) \
  --export-height=$((HEIGHT/2)) \
  --export-type=png \
  -o $LOGO-small.png \
  $LOGO.svg

inkscape \
  --export-area-page \
  --export-width=$((WIDTH*2)) \
  --export-height=$((HEIGHT*2)) \
  --export-type=png \
  -o $LOGO-medium.png \
  $LOGO.svg

# icons
for i in 32 48 64 128 256 512; do
# generate png
inkscape \
  --export-area-page \
  --export-width=$i \
  --export-height=$i \
  --export-type=png \
  -o $ICON-${i}x${i}.png \
  $ICON.svg
done

img2sixel --bgcolor '#000000' < usql.png > usql.sixel

popd &> /dev/null
