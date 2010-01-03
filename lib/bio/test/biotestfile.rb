# 
# biotestfile.rb
#
# Copyright (C) 2010 Pjotr Prins <pjotr.prins@thebird.nl> 
#

module BioTestFile

  TEST_DATA = "#{ENV['BIORUBY_HOME']}/test/data"

  # Read +fn+ from the test data directory
  def BioTestFile::read fn
    File.read(TEST_DATA+'/'+fn)
  end
end
