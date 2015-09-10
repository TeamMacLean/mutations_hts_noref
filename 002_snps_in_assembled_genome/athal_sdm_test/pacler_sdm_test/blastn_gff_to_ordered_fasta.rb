#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'
require 'csv'

### command line input
### ruby blastn_gff_to_ordered_fasta.rb 'blast input fasta file' 'blastn gff file' > stdout fasta file

### Read sequence fasta file and store sequences in a hash
sequences = Hash.new {|h,k| h[k] = {} }
file = Bio::FastaFormat.open(ARGV[0])
file.each do |seq|
	sequences[seq.entry_id] = seq.entry
end

### Read gff and store chromosome covered sequences from hash to sort
gff = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
gff3 = Bio::GFF::GFF3.new(File.read(ARGV[1]))
assembled_length = 0
gff3.records.each do | record |
	if record.feature == 'gene'
		geneid = record.get_attributes('ID')[0]
		chr = record.seqname.gsub(/^Chr/, '')
		gff[chr][record.start.to_i][geneid] = record
		assembled_length += record.end.to_i - record.start.to_i
	end
end
warn "assembled chromosome length:\t#{assembled_length}"

### sequences are ordered from chromosome 1 to 5, C and M for arabidopsis
gff.keys.sort.each do | chromosome |
	gff[chromosome].keys.sort.each do | position |
		gff[chromosome][position].keys.each do | gene |
			if sequences.has_key?(gene)
				puts "#{sequences[gene]}"
			else
				warn "No seqeunce for\t #{gene}\n"
			end
		end
	end
end
