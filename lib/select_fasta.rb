#!/usr/bin/ruby
# encoding: utf-8
#

require 'bio'

### script to read a fasta file and discard sequence less than selected length
### Read sequence fasta file and print sequnces longer than selected length

discard = 0
file = Bio::FastaFormat.open(ARGV[0])
file.each do |seq|
	if seq.length >= 500
		puts "#{seq.entry}"
	else
		discard += 1
	end
end

warn "number of seqeunces discarded\t#{discard}\n"
