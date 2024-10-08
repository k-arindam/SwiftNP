#!/bin/bash

opath="./docs/"
bpath="./docs/"

rm -rf $opath

swift package --allow-writing-to-directory $opath \
 generate-documentation --disable-indexing \
  --output-path $opath \
   --transform-for-static-hosting
    # --hosting-base-path $bpath