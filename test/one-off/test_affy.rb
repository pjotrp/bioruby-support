if $0 == __FILE__

  print "Testing Affy...\n"

  $: << '../../../'

  require 'bio'
  require 'affyprobemap'
  require 'affyprobeset'

  datadir = ENV['HOME']+'/izip/svn/opensource/biolib/src/test/data/microarray/affy'
  celfn = datadir+'/test_binary.cel.gz'
  cdffn = '/tmp/test_cdf.dat'

  print `zcat #{datadir}/test_cdf.dat.gz > /tmp/test_cdf.dat`
  probemap = Bio::Microarray::AffyProbemap.new(cdffn)
  m        = Bio::Microarray::Affy.new(celfn,probemap)
  p m.probe(0)
  m.probemap = probemap # superfluous
  # hard wired
  probeset0 = probemap.probeset_info(0)
  p probeset0.pm_num
  # better
  probeset = m.probeset(11115)
  probeset.show

end
