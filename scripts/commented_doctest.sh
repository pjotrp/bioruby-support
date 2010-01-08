#! /bin/sh
#
# Run Rubydoctest on Pjotr's machines
#
#

~/izip/git/opensource/bioruby-support/bin/uncomment_doctest $* > mydoc.test
~/izip/git/opensource/bioruby-support/scripts/rubydoctest.sh mydoc.test
