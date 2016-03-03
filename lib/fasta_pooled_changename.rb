#encoding: utf-8
require 'bio'

name_part = ARGV[0].chomp
len_cutoff = ARGV[1].chomp.to_i
fastafiles = Dir.glob("*.#{name_part}").select {|f| File.file? f}
number = 1
fastafiles.each do | file |
  Bio::FastaFormat.open(file).each do |i|
    if i.length >= len_cutoff
      seqout = Bio::Sequence::NA.new(i.seq).upcase
      puts seqout.to_fasta("contig-#{i.entry_id}-#{number}", 60)
      number += 1
    end
  end
end
