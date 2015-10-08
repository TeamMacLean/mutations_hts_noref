#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'
require 'bio-samtools'

### command line input
### ruby ordered_fasta_vcf_positions 'ordered fasta file' 'shuffled vcf file'  writes ordered variant positions to text files and
### a vcf file with name corrected contigs/scaffolds and "AF" entry to info field

assembly_len = 0
### Read ordered fasta file and store sequence id and lengths in a hash
sequences = Hash.new {|h,k| h[k] = {} }
file = Bio::FastaFormat.open(ARGV[0])
file.each do |seq|
	sequences[seq.entry_id] = [assembly_len, seq.length.to_i].join("_")
	assembly_len += seq.length.to_i
end


### Read sequence fasta file and store sequences in a hash
contigs = Hash.new {|h,k| h[k] = {} }
File.open(ARGV[1], 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	if v.info["AF"].to_f == 1.0
		if contigs[v.chrom].has_key?(:hm)
			contigs[v.chrom][:hm] += 1
		else
			contigs[v.chrom][:hm] = 1
		end
	elsif v.info["AF"].to_f == 0.5
		if contigs[v.chrom].has_key?(:ht)
			contigs[v.chrom][:ht] += 1
		else
			contigs[v.chrom][:ht] = 1
		end
	end
end

puts "Chr\tassembly\tlength\tnumhm\tnumht"
sequences.each_key do |key|
	info = sequences[key].split(/_/)
	hm = 0
	ht = 0
	if contigs.has_key?(key)
		if contigs[key].has_key?(:hm)
			hm = contigs[key][:hm]
		end
		if contigs[key].has_key?(:ht)
			ht = contigs[key][:ht]
		end
	end
	puts "#{key}\t#{info[0]}\t#{info[1]}\t#{hm}\t#{ht}"
end
