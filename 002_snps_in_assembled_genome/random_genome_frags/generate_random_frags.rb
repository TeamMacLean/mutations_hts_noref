require 'simple-random'
require 'bio'
require 'fileutils'
require 'yaml'
pars = YAML.load_file("frag_pars.yml")

# mean, std deviation and sample size to generate random numbers
# add additonal 10% to sample number to be able to cover the whole genome length
sample = pars['sample']  # 9600 + 500 random numbers (contig number)
mean = pars['mean']   # 11885 bp is mean / 7.889536 is mean of log of lengths
sd = pars['sd']    # 30160 bp is std. deviation / 1.56288 is sd of log of lengths
iterations = pars['iterations'] # number of iterations of framenting

# a hash of chromosome sequences and accumulated lengths
genome_length = 0
chrseq = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
Bio::FastaFormat.open(ARGV[3]).each do |inseq|
	chrseq[:seq][inseq.entry_id] = inseq.seq.to_s
	chrseq[:len][inseq.entry_id] = genome_length
	genome_length += inseq.length
	warn "#{inseq.entry_id}\n"
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

### open files to write snp outputs
hmfile = File.open("hm_snps.txt", 'w')
htfile = File.open("ht_snps.txt", 'w')
snpfile = File.open("snps.vcf", 'w')

### Read sequence fasta file and store sequences in a hash
vars = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
File.open(ARGV[1], 'r').each do |line|
	if line =~ /^#/
		snpfile.puts "#{line}"
	else
		v = Bio::DB::Vcf.new(line)
		if chrseq[:len].has_key?(v.chrom.to_s)
			if v.info["HET"].to_i == 1
				v.info["AF"] = 0.5
				v.pos = v.pos.to_i + chrseq[:len][v.chrom.to_s]
				vars[v.pos] = v
				htfile.puts "#{v.pos}"
			elsif v.info["HOM"].to_i == 1
				v.info["AF"] = 1.0
				v.pos = v.pos.to_i + chrseq[:len][v.chrom.to_s]
				vars[v.pos] = v
				hmfile.puts "#{v.pos}"
			end
		else
			warn "No sequnce in fasta file for\t#{v.chrom.to_s}\n"
		end
	end
end

@random = SimpleRandom.new
FileUtils.mkdir_p "outseq_lengths"

for iteration in 1..iterations
	# generate an array of random numbers using mean and sample number provided
	# exponential distribution is used
	@random.set_seed
	number_array = []
	i = 0
	while i < sample
		# number = @random.exponential(mean).to_i
		number = @random.log_normal(mean, sd).to_i
		if number.between?(500, 500000)
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
		seq = chrseq[id].dup
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

	# write ordered and shuffled fragments in a new folder for current iteration
	newname = "genome_" + iteration.to_s
	FileUtils.mkdir_p "#{newname}"
	# copy vcf and variant location file to iteration folder
	%x[cp hm_snps.txt #{newname}/hm_snps.txt]
	%x[cp ht_snps.txt #{newname}/ht_snps.txt]
	%x[cp snps.vcf #{newname}/snps.vcf]

	snpvcf = File.open("#{newname}/snps.vcf", 'w+')

	write_fasta(frags, frags.keys.sort, "#{newname}/frags_ordered.fasta")

	shuffled = frags.keys.shuffle(random: Random.new_seed)
	write_fasta(frags, shuffled, "#{newname}/frags_shuffled.fasta")

	output = File.open("outseq_lengths/#{newname}_lengths.txt", 'w')
	output.puts "fragment_id\tlength"
	Bio::FastaFormat.open("#{newname}/frags_shuffled.fasta").each do |i|
    	output.puts "#{i.entry_id}\t#{i.length}"
	end

	warn "sequences fragment iteration:\t#{iteration}\n"

end
