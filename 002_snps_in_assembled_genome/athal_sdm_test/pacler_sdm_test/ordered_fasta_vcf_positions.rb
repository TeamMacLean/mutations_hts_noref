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
	sequences[seq.entry_id] = assembly_len
	assembly_len += seq.length.to_i
end


### open files to write snp outputs
hmfile = File.open("hm_snps.txt", 'w')
htfile = File.open("ht_snps.txt", 'w')
snpfile = File.open("snps.vcf", 'w')

### Read sequence fasta file and store sequences in a hash
File.open(ARGV[1], 'r').each do |line|
	if line =~ /^#/
		snpfile.puts "#{line}"
	else
		v = Bio::DB::Vcf.new(line)
		v.chrom = v.chrom.gsub(/\|quiver$/, "")
		if sequences.has_key?(v.chrom.to_s)
			if v.info["HET"].to_i == 1
				v.info["AF"] = 0.5
				snpfile.puts "#{v.to_s}"
				v.pos = v.pos.to_i + sequences[v.chrom.to_s]
				htfile.puts "#{v.pos}"
			elsif v.info["HOM"].to_i == 1
				v.info["AF"] = 1.0
				snpfile.puts "#{v.to_s}"
				v.pos = v.pos.to_i + sequences[v.chrom.to_s]
				hmfile.puts "#{v.pos}"
			end
		else
			warn "#{v.chrom.to_s}\n"
		end
	end
end
