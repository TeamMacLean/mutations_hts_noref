require 'simple-random'
require 'bio'

mean = ARGV[0].to_i
sample = ARGV[1].to_i
sd = ARGV[2].to_i

@random = SimpleRandom.new
@random.set_seed

number_array = []
(1..sample).each do
	number = @random.exponential(mean).to_i
	if number >= 500
		number_array << number
	end
end

seq_string = []
n = 0
Bio::FastaFormat.open(ARGV[3]).each do |i|
	seq_string[n] = i.seq.to_s
	n += 1
end

frags = []
seq_string.each do | seq |
	while seq.length > 500
		if seq.length < 1000
			frags << seq.slice!(0..-1)
		else
			index = number_array.shift.to_i
			frags << seq.slice!(0...index)
		end
	end
end

name_index = 1
frags.each do | fragment |
	seqout = Bio::Sequence::NA.new(fragment)
	puts seqout.to_fasta("seq_id_#{name_index}", 80)
	name_index += 1
end
