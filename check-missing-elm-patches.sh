#!/bin/sh
#

set -e

r105_patches=".r105-patches"
elm_patches=".elm_patches"

git log --pretty=format:"%h %s" cos-kernel/tcpd/R105 ^14470c6e25ff --first-parent --no-merges > $r105_patches

git log --pretty=format:"%h %s" cos-kernel/tcpd/elm3 ^upstream/v5.4.210 --first-parent --no-merges > $elm_patches

while read line; do
  patch=${line#* }
  grep -q "$patch" $elm_patches || echo not found $line
done <$r105_patches
