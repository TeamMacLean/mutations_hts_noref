require 'simple-random'
require 'bio'
require 'fileutils'

# mean, std deviation and sample size to generate random numbers
# add additonal 10% to sample number to be able cover the whole genome length
mean = ARGV[0].to_i   # 11885 bp is mean
sample = ARGV[1].to_i # 9600 + 500 random numbers (contig number)
sd = ARGV[2].to_i     # 30160 bp is std. deviation

# a hash of chromosome sequences
genome_length = 0
chrseq = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
Bio::FastaFormat.open(ARGV[3]).each do |inseq|
	chrseq[inseq.entry_id] = inseq.seq.to_s
	genome_length += inseq.length
	warn "#{inseq.entry_id}\n"
end

iterations = ARGV[4].to_i
@random = SimpleRandom.new
FileUtils.mkdir_p "outseq_lengths"

for iteration in 1..iterations
	# generate an array of random numbers using mean and sample number provided
	# exponential distribution is used
	@random.set_seed
	number_array = []
	i = 0
	while i < sample
		number = @random.exponential(mean).to_i
		if number >= 500
			number_array << number
			i += 1
		end
	end

	# adding a break to the loop if the random numbers do not cover the genome
	if number_array.reduce(:+) < genome_length
		warn "Increase sample number to cover the genome length\n"
		break
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

	newname = "genome_" + iteration.to_s
	FileUtils.mkdir_p "#{newname}"

	write_fasta(frags, frags.keys.sort, "#{newname}/frags_ordered.fasta")

	shuffled = frags.keys.shuffle(random: Random.new_seed)
	write_fasta(frags, shuffled, "#{newname}/frags_shuffled.fasta")

	output = File.open("outseq_lengths/#{newname}_lengths.txt", 'w')
	Bio::FastaFormat.open("#{newname}/frags_shuffled.fasta").each do |i|
    	output.puts "#{i.entry_id}\t#{i.length}"
	end

	warn "sequences fragment iteration:\t#{iteration}\n"

end
