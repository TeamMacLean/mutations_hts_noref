require 'simple-random'
require 'bio'

# mean, std deviation and sample size to generate random numbers
mean = ARGV[0].to_i
sample = ARGV[1].to_i
sd = ARGV[2].to_i

# generate an array of random numbers using mean and sample number provided
# exponential distribution is used
@random = SimpleRandom.new
@random.set_seed
number_array = []
(1..sample).each do
	number = @random.exponential(mean).to_i
	if number >= 500
		number_array << number
	end
end

# a hash of chromosome sequences
chrseq = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
Bio::FastaFormat.open(ARGV[3]).each do |i|
	chrseq[i.entry_id] = i.seq.to_s
	warn "#{i.entry_id}\n"
end

# chromosme sequences are fragemened to the sizes in random number array
# and saved to a hash
frags = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
name_index = 1
chrseq.keys.sort.each do | id |
	seq = chrseq[id]
	while seq.length > 500
		if seq.length < 1000
			frags[name_index] = seq.slice!(0..-1)
		else
			index = number_array.shift.to_i
			frags[name_index] = seq.slice!(0...index)
		end
		name_index += 1
	end
end

# write fasta frag hash to a file
# array of ids provided either sorted or shuffled
def write_fasta(hash, array, filename)
	outfile = File.open(filename, 'w')
	array.each do | element |
		seqout = Bio::Sequence::NA.new(hash[element])
		outfile.puts seqout.to_fasta("seq_id_#{element}", 80)
	end
end

write_fasta(frags, frags.keys.sort, 'frags_ordered.fasta')

shuffled = frags.keys.shuffle(random: Random.new_seed)
write_fasta(frags, shuffled, 'frags_shuffled.fasta')

