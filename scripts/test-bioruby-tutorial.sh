#! /bin/bash
#
#  This script prepares the ./doc/Tutorial.rd for rubydoctest

tutorial=$1

#  Convert the 'bioruby>' and '==>' markers
cat $tutorial | sed -e "s,bioruby>,>>," | sed "s,==>,=>," > $tutorial.doctest
~/izip/git/opensource/rubydoctest/bin/rubydoctest $tutorial.doctest
rm -v $tutorial.doctest

