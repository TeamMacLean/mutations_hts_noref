require 'bio'
require 'bio-samtools'
require 'fileutils'


# open a fasta file and store sequence ids and lengths to hash
seqs = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
Bio::FastaFormat.open(ARGV[0]).each do |i|
	seqs[i.entry_id] = i.length.to_i
end

# read variants vcf file and count number of variants for each fragment
vars = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
File.open(ARGV[1], 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	if v.info["HET"].to_i == 1
		if vars[:ht].key?(v.chrom.to_s)
			vars[:ht][v.chrom.to_s] += 1
		else
			vars[:ht][v.chrom.to_s] = 1
		end
	elsif v.info["HOM"].to_i == 1
		if vars[:hm].key?(v.chrom.to_s)
			vars[:hm][v.chrom.to_s] += 1
		else
			vars[:hm][v.chrom.to_s] = 1
		end
	end
end

puts "fragment\tlength\tnumhm\tnumht"
# go through each sequence and print lenght and number of vars (homozygous and heterozygous)
seqs.keys.sort.each do | seqid |
	hm = 0
	hm = vars[:hm][seqid.to_s] if vars[:hm].key?(seqid.to_s)

	ht = 0
	ht = vars[:ht][seqid.to_s] if vars[:ht].key?(seqid.to_s)

	puts "#{seqid}\t#{seqs[seqid]}\t#{hm}\t#{ht}"
end
