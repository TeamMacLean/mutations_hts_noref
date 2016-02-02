#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'
require 'bio-samtools'

### command line input
### ruby ordered_fasta_vcf_positions 'ordered fasta file' 'shuffled vcf file' 'chr:position'  writes ordered variant positions to text files and
### a vcf file with name corrected contigs/scaffolds and "AF" entry to info field

def rename_chr(chr)
  chr_id = { "gi|366157031" => 4,
    "gi|366157028" => 2,
    "gi|366157039" => 12,
    "gi|366157038" => 11,
    "gi|366157037" => 10,
    "gi|366157036" => 9,
    "gi|366157035" => 8,
    "gi|366157034" => 7,
    "gi|366157033" => 6,
    "gi|366157032" => 5,
    "gi|366157030" => 3,
    "gi|366157029" => 1 }
  id = /^(?<name>gi\|\d{9})/.match(chr)[:name]
  new_chr = chr_id[id]
  new_chr
end

### Read ordered fasta file and store sequence id and lengths in a hash
seqs = Hash.new {|h,k| h[k] = {} }
file = Bio::FastaFormat.open(ARGV[0])
file.each do |seq|
  id = rename_chr(seq.entry_id)
  seqs[id.to_i] = seq.length.to_i
end

assembly_len = 0
sequences = Hash.new {|h,k| h[k] = {} }
seqs.keys.sort.each do | newid |
  sequences[newid] = assembly_len
  assembly_len += seqs[newid]
  warn "#{newid}\t#{seqs[newid]}\t#{assembly_len}\n"
end

### Read sequence fasta file and store sequences in a hash
contigs = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
infile = ARGV[1]
varfile = File.new("varposn-genome-#{infile}.txt", "w")
varfile.puts "position\ttype"
File.open(infile, 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	v.chrom = rename_chr(v.chrom)
	v.pos = v.pos.to_i + sequences[v.chrom]
	if v.info["HOM"].to_i == 1
		contigs[:hm][v.pos] = 1
		varfile.puts "#{v.pos}\thm"
	elsif v.info["HET"].to_i == 1
		contigs[:ht][v.pos] = 1
		varfile.puts "#{v.pos}\tht"
	end
end

# argument 3 provides the chromosome id and position of causative mutation seperated by ':'
# this is used to get position in the sequential order of the chromosomes
unless ARGV[2].nil?
	info = ARGV[2].split(/:/)
	adjust_posn = sequences[info[0].to_i] + info[1].to_i
	warn "adjusted mutation position\t#{adjust_posn}"
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

breaks = [10000, 50000, 100000, 500000, 1000000, 5000000, 10000000]
breaks.each do | step |
	outfile = open_new_file_to_write(infile, step)
	distribute = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
	distribute = pool_variants_per_step(contigs, step, distribute, :hm)
	distribute = pool_variants_per_step(contigs, step, distribute, :ht)
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