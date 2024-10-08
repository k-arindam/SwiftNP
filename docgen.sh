#!/bin/bash

opath="./docs/"

swift package --allow-writing-to-directory $opath generate-documentation --disable-indexing --output-path $opath