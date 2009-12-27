#! /bin/bash
#
#  This script prepares the ./doc/Tutorial.rd for rubydoctest

tutorial=$1

#  Convert the 'bioruby>' and '==>' markers

cat Tutorial.rd | sed -e "s,bioruby>,>>," | sed "s,==>,=>," > Tutorial.rd.tmp ; ruby -I~/izip/git/opensource/biolib/lib ../../biolib/tools/rubydoctest/bin/rubydoctest Tutorial.rd.tmp
