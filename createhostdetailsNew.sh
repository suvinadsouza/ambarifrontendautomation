#!/bin/bash

hostdetails=$1

# List hosts we're going to try to connect to
sed -e '/^\s*$/ d' -e '/^#/ d' $hostdetails | while read line; do
    echo $line
done
