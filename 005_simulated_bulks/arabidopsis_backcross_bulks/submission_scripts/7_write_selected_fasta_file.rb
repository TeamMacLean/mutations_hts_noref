#encoding: utf-8
require 'bio'

seqids = {}
File.open(ARGV[0]).each_line do | line |
  unless line == '' or line =~ /^Score/
    info = line.chomp.split("\t")
    seqids[info[3]] = 1
  end
end
warn "Num of seqs to select\t#{seqids.length}"

Bio::FastaFormat.open(ARGV[1]).each do |i|
  if seqids.key?(i.entry_id.to_s)
    puts "#{i.entry}"
  end
end


