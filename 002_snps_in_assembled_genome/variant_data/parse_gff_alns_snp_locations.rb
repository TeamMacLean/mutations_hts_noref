#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'
require 'csv'

### command line input
### ruby parse_gff_alns_snp_locations.rb blastn_to_gf_file Chromosome-number variant_file custom_filename
### variant file should be in the same directory, where script is executed

### Read gff and selected chromosome coverage is stored in a hash
data = Hash.new {|h,k| h[k] = {} }
gff3 = Bio::GFF::GFF3.new(File.read(ARGV[0]))
chr = ARGV[1].chomp
assembled_length = 0
gff3.records.each do | record |
	if record.seqname.to_s == chr
		if record.feature == 'mRNA'
			data[record.start.to_i] = [record.start, record.end].join("_")
			assembled_length += record.end.to_i - record.start.to_i
		end
	end
end
warn "assembled chromosome length:\t#{assembled_length}"

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
		if curr_start - prev_end > 100
			curr_gap += curr_start - prev_end
			nocov[count] = [prev_end, curr_start, curr_gap].join("_")
			# warn "notcovered\t#{nocov[count]}\n"
			count += 1
		end
		prev_end = curr_end
	end
end

### Read SNP positions from file and add them to an array and sort them numerically
positions = []
lines = File.read(ARGV[2])
lines.split("\n").each do |line|
	positions.push line.to_i
end
sorted_snp = positions.sort

customname = [ARGV[3].chomp, ARGV[2].chomp].join("_")
outfile1 = File.new("no_vars_#{customname}", "w")
outfile2 = File.new("vars_#{customname}", "w")

### Check if SNP's are in no sequence read coverage area and discard them
### And adjust remaining SNP position accordingly
subtract = 0
gap_present = 0
sorted_snp.each do | posn |
	in_gap = 0
	nocov.keys.sort.each do | key |
		info = nocov[key].split("_")
		start = info[0].to_i
		end_p = info[1].to_i
		if start < posn.to_i and posn.to_i < end_p
			subtract = info[2]
			outfile1.puts "#{posn}"
			gap_present = 1
			in_gap = 1
			# warn "#{posn}\t#{start}\t#{end_p}\t#{key}\n"
			break
		end
	end
	# warn "#{posn}\t#{gap_present}\t#{in_gap}\n"
	if gap_present == 1
		if in_gap == 0
			outfile2.puts "#{posn.to_i - subtract.to_i}"
		end
	else
		outfile2.puts "#{posn}"
	end
end
