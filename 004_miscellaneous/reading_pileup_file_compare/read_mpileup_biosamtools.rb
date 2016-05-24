# encoding: utf-8

require 'bio-samtools'
require 'bio-gngm'

vars_hash = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

File.foreach(ARGV[0]) do |line|
  pileup = Bio::DB::Pileup.new(line)
  if pileup.is_snp?(:ignore_reference_n => true, :min_depth => 6, :min_non_ref_count => 3)
    vars_hash[pileup.ref_name][pileup.pos] = pileup.coverage
  end
end

