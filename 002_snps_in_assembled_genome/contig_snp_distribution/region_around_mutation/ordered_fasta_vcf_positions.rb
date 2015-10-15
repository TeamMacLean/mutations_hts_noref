#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'
require 'bio-samtools'

### command line input
### ruby ordered_fasta_vcf_positions 'ordered fasta file' 'shuffled vcf file' 'chr:position'  writes ordered variant positions to text files and
### a vcf file with name corrected contigs/scaffolds and "AF" entry to info field

assembly_len = 0
### Read ordered fasta file and store sequence id and lengths in a hash
sequences = Hash.new {|h,k| h[k] = {} }
file = Bio::FastaFormat.open(ARGV[0])
file.each do |seq|
	sequences[seq.entry_id] = assembly_len
	assembly_len += seq.length.to_i
end

# argument 3 provides the chromosome id and position of causative mutation seperated by ':'
# this is used to get position in the sequential order of the chromosomes
info = ARGV[2].split(/:/)
adjust_posn = sequences[info[0].to_s] + info[1].to_i
warn "adjusted mutation position\t#{adjust_posn}"

# using limits of 50Mb, 25Mb, 10Mb, 5Mb and 1Mb around the causative mutation
limits = [25000000, 12500000, 5000000, 2500000, 1250000]
seq_limit = Hash.new {|h,k| h[k] = {} }
limits.each do | delimit |
	lower = 0
	if (adjust_posn - delimit) > 0
		lower = adjust_posn - delimit
	end

	upper = adjust_posn + delimit
	if upper > assembly_len
		upper = assembly_len
	end
	seq_limit[delimit*2] = [lower, upper].join(':')
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
#varfile = File.new("varposn-genome-#{infile}.txt", "w")
#varfile.puts "position\ttype"
File.open(infile, 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	v.chrom = rename_chr(v.chrom)
	v.pos = v.pos.to_i + sequences[v.chrom]
	seq_limit.each_key do | limit |
		limits = seq_limit[limit].split(':')
		if v.pos.between?(limits[0].to_i, limits[1].to_i)
			if v.info["HOM"].to_i == 1
				contigs[limit][:hm][v.pos] = 1
				# varfile.puts "#{v.pos}\thm"
			elsif v.info["HET"].to_i == 1
				contigs[limit][:ht][v.pos] = 1
				# varfile.puts "#{v.pos}\tht"
			end
		end
	end
end

# New file is opened to write
def open_new_file_to_write(input, number, region)
	outfile = File.new("#{region}-per#{number}bp-#{input}.txt", "w")
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

def pool_variants_per_step(inhash, step, outhash, vartype)
	slice = step
	inhash[vartype].keys.sort.each do | pos |
		if outhash[step].key?(vartype) == FALSE
			outhash[step][vartype] = 0
		end
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
	outhash
end

breaks = [10000, 100000, 500000]
breaks.each do | step |
	contigs.each_key do | region |
		outfile = open_new_file_to_write(infile, step, region)
		distribute = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
		distribute = pool_variants_per_step(contigs[region], step, distribute, :hm)
		distribute = pool_variants_per_step(contigs[region], step, distribute, :ht)
		distribute.each_key do | key |
			hm = 0
			ht = 0
			if distribute[key].key?(:hm)
				hm = distribute[key][:hm]
			end
			if distribute[key].key?(:ht)
				ht = distribute[key][:ht]
			end
			outfile.puts "#{key}\t#{hm}\t#{ht}"
		end
	end
end
