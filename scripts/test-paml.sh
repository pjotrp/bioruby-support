#! /bin/sh

echo "Running tests for PAML"

cd ~/izip/git/opensource/bioruby/test

ruby runner.rb -t Bio::TestPAMLCodeml::TestCodemlRates -t Bio::TestPAMLCodeml::TestCodemlReport -t Bio::TestPAMLCodeml::TestCodemlInitialize -t Bio::TestPAMLCodeml::TestCodeml -t Bio::TestPAMLCodeml::TestCodemlControlGeneration -t Bio::TestPAMLCodeml::TestControlFileUsage -t Bio::TestPAMLCodeml::TestExpectedErrorsThrown

