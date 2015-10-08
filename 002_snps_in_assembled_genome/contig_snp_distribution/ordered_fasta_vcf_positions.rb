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

def rename_chr(chr)
	if chr =~ /^Chr\d/
		chr.gsub!(/^Chr/, '')
	elsif chr =~ /^ChrM/
		chr.gsub!(/^ChrM/, 'mitochondria')
	elsif chr =~ /^ChrC/
		chr.gsub!(/^ChrC/, 'chloroplast')
	end
	chr
end

### Read sequence fasta file and store sequences in a hash
contigs = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
infile = ARGV[1]
File.open(infile, 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	v.chrom = rename_chr(v.chrom)
	if v.info["HOM"].to_i == 1
		contigs[v.chrom][:hm][v.pos.to_i] = 1
	elsif v.info["HET"].to_i == 1
		contigs[v.chrom][:ht][v.pos.to_i] = 1
	end
end

puts "Chr\tassembly\tlength\tnumhm\tnumht"
sequences.each_key do |key|
	info = sequences[key].split(/_/)
	hm = 0
	ht = 0
	if contigs.has_key?(key)
		if contigs[key].has_key?(:hm)
			hm = contigs[key][:hm].length
		end
		if contigs[key].has_key?(:ht)
			ht = contigs[key][:ht].length
		end
	end
	puts "#{key}\t#{info[0]}\t#{info[1]}\t#{hm}\t#{ht}"
end

# New file is opened to write
def open_new_file_to_write(input, number)
	outfile = File.new("per-#{number}bp-#{input}.txt", "w")
	outfile.puts "position\tnumhm\tnumht"
	outfile
end

def enumerate_snps(outhash, step, vartype)
	if outhash[step].has_key?(vartype)
		outhash[step][vartype] += 1
	else
		outhash[step][vartype] = 1
	end
	outhash
end

def pool_variants_per_step(inhash, assembly, slice, step, outhash, vartype)
	inhash[vartype].keys.sort.each do | pos |
		pos += assembly.to_i
		outhash[step][vartype] = 0
		if pos <= step
			outhash = enumerate_snps(outhash, step, vartype)
		else
			num_loop = ((pos-step)/slice.to_f).ceil
			for i in 1..num_loop do
				step += slice
				if outhash[step].key?(vartype) == FALSE
					outhash[step][vartype] = 0
				end
			end
			outhash = enumerate_snps(outhash, step, vartype)
		end
	end
	[outhash, step]
end

breaks = [10000, 50000, 100000, 500000, 1000000]
breaks.each do | step |
	slice = step
	outfile = open_new_file_to_write(infile, step)
	distribute = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
	contigs.keys.sort.each do | chrom |
		info = sequences[chrom].split(/_/)
		distribute, step = pool_variants_per_step(contigs[chrom], info[0], slice, step, distribute, :hm)
		#distribute, step = pool_variants_per_step(contigs[chrom], info[0], slice, step, distribute, :ht)
		#step = step
	end
	distribute.each_key do | key |
		outfile.puts "#{key}\t#{distribute[key][:hm]}\t#{distribute[key][:ht]}"
	end
end