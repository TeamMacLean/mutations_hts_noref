#encoding: utf-8
require 'bio'

indir_files = ARGV[0] + "/*.scafSeq.gz"
sel_len = ARGV[1].to_i

Dir.glob(indir_files) do |scaf_file|
  tempfile = File.basename(scaf_file, '.gz')
  outfile = 'selected_' + tempfile + '.fa'
  warn "#{scaf_file}\t#{tempfile}\t#{outfile}"

  %x[gzip -dc #{scaf_file} > #{tempfile} ]
  writefile = File.open(outfile, 'w')
  Bio::FastaFormat.open(tempfile).each do |i|
    if i.length >= sel_len
      # warn "#{i.seq.composition}\n"
      seqout = Bio::Sequence::NA.new(i.seq).upcase
      writefile.puts seqout.to_fasta("#{i.definition}", 80)
    end
  end
  %x[rm #{tempfile}]
  writefile.close
end

