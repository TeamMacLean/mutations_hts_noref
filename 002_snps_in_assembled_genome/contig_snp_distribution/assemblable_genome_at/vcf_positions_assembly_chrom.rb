#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'
require 'bio-samtools'

### command line input
### ruby ordered_fasta_vcf_positions 'ordered fasta file' 'shuffled vcf file' 'chr:position'  writes ordered variant positions to text files and
### a vcf file with name corrected contigs/scaffolds and "AF" entry to info field

fastafile = ARGV[0]
vcffile = ARGV[1]
gfffile = ARGV[2] # gff file of denovo assembly over the fasta file

genome_len = 0
### Read ordered fasta file and store sequence id and lengths in a hash
sequences = Hash.new {|h,k| h[k] = {} }
file = Bio::FastaFormat.open(fastafile)
file.each do |seq|
	sequences[seq.entry_id] = genome_len
	genome_len += seq.length.to_i
end
warn "whole genome length:\t#{genome_len}"

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

### Read gff and selected chromosome coverage is stored in a hash
data = Hash.new {|h,k| h[k] = {} }
gff3 = Bio::GFF::GFF3.new(File.read(gfffile))
assembled_length = 0
covered_length = 0
gff3.records.each do | record |
	chr = rename_chr(record.seqname.to_s)
	if record.feature == 'gene'
		record.start = sequences[chr] + record.start.to_i
		record.end = sequences[chr] + record.end.to_i
		data[record.start.to_i] = [record.start, record.end].join("_")
		# assembled_length += record.end - record.start
		length = record.get_attributes('original_length')[0].to_i
		assembled_length += length
		covlength = record.get_attributes('length_covered')[0].to_i
		covered_length += covlength
	end
end
warn "assembled genome length:\t#{assembled_length}"
warn "assembly covering the genome:\t#{covered_length}"

### Use stored hash to calculate uncovered genomic region and add to a hash
nocov = Hash.new {|h,k| h[k] = {} }
curr_gap = 0
prev_end = 0
count = 1
data.keys.sort.each do | key |
	info = data[key].split("_")
	# warn "covered\t#{data[key]}\n"
	curr_start = info[0].to_i
	curr_end = info[1].to_i
	if prev_end == 0
		prev_end = curr_end
	else
		gap = curr_start - prev_end
		if gap > 100
			curr_gap += gap
			nocov[count] = [prev_end, curr_start, curr_gap].join("_")
			# warn "notcovered\t#{nocov[count]}\n"
			count += 1
		end
		prev_end = curr_end
	end
end

def notin_asmbly_check(nocov, varpos, subtract, gap_present, in_gap)
	nocov.keys.sort.each do | key |
		info = nocov[key].split("_")
		start = info[0].to_i
		end_p = info[1].to_i
		if varpos.between?(start, end_p)
			subtract = info[2].to_i
			gap_present = 1
			in_gap = 1
			break
		end
	end
	[subtract, in_gap, gap_present]
end

### Check if SNP's are in no sequence read coverage area and discard them
### And adjust remaining SNP position accordingly
subtract = 0
gap_present = 0

### Read vcf file and store variants in respective 
contigs = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
varfile = File.new("varposn-genome-#{vcffile}.txt", "w")
varfile.puts "position\ttype"
File.open(vcffile, 'r').each do |line|
	next if line =~ /^#/
	v = Bio::DB::Vcf.new(line)
	v.chrom = rename_chr(v.chrom)
	v.pos = v.pos.to_i + sequences[v.chrom]
	type = ''
	if v.info["HOM"].to_i == 1
		type = 'hm'
	elsif v.info["HET"].to_i == 1
		type = 'ht'
	end

	in_gap = 0
	subtract, in_gap, gap_present = notin_asmbly_check(nocov, v.pos, subtract, gap_present, in_gap)
	if gap_present == 1
		if in_gap == 0
			adj_pos = v.pos - subtract
			contigs[type][adj_pos] = 1
			varfile.puts "#{adj_pos}\t#{type}"
		end
	else
		contigs[type][v.pos] = 1
		varfile.puts "#{v.pos}\t#{type}"
	end
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
	outfile = open_new_file_to_write(vcffile, step)
	distribute = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
	distribute = pool_variants_per_step(contigs, step, distribute, 'hm')
	distribute = pool_variants_per_step(contigs, step, distribute, 'ht')
	distribute.each_key do | key |
		hm = 0
		ht = 0
		if distribute[key].key?('hm')
			hm = distribute[key]['hm']
		end
		if distribute[key].key?('ht')
			ht = distribute[key]['ht']
		end
		outfile.puts "#{key}\t#{hm}\t#{ht}"
	end
end
