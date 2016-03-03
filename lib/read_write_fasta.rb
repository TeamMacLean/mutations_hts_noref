#encoding: utf-8
require 'bio'

sel_len = ARGV[1].to_i
Bio::FastaFormat.open(ARGV[0]).each do |i|
  if i.length >= sel_len
    # warn "#{i.seq.composition}\n"
    seqout = Bio::Sequence::NA.new(i.seq).upcase
    puts seqout.to_fasta("#{i.definition}", 80)
  end
end
