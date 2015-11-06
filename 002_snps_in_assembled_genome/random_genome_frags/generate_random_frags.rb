require 'simple-random'
require 'bio'
require 'bio-samtools'
require 'fileutils'
require 'yaml'

pars = YAML.load_file("frag_pars.yml")

# mean, std deviation and sample size to generate random numbers
# add additonal 10% to sample number to be able to cover the whole genome length
sample = pars['sample']  # 9600 + 500 random numbers (contig number)
mean = pars['mean']   # 11885 bp is mean / 7.889536 is mean of log of lengths
sd = pars['sd']    # 30160 bp is std. deviation / 1.56288 is sd of log of lengths
iterations = pars['iterations'] # number of iterations of framenting
@discard_n = pars['discard_n'] # boolean option to discarding sequences with 50% or more 'N's

# a hash of chromosome sequences and accumulated lengths
genome_length = 0
chrseq = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
Bio::FastaFormat.open(ARGV[0]).each do |inseq|
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

# spliced sequence based on random length
# and deatils added to a hash with sequence and length informations
# if selected discard fragments having 50% or more ambiguous nucleotides
def splice_sequence (inseq, nameindex, lenindex, fragshash, discardsfile)
	seqlen = inseq.length
	if @discard_n
		ncount = inseq.scan(/n/i).count
		if ncount >= seqlen/2
			#warn "#{ncount}\t#{nameindex}\t#{discardsfile}\n"
			seqout = Bio::Sequence::NA.new(inseq)
			discardsfile.puts seqout.to_fasta("seq_id_#{nameindex}", 80)
		else
			fragshash[:seq][nameindex] = inseq
			fragshash[:len][nameindex] = [lenindex, lenindex+seqlen].join(':')
			lenindex += seqlen
		end
	else
		fragshash[:seq][nameindex] = inseq
		fragshash[:len][nameindex] = [lenindex, lenindex+seqlen].join(':')
		lenindex += seqlen
	end
	[fragshash, lenindex]
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
				vars[v.pos] = v.to_s
				htfile.puts "#{v.pos}"
			elsif v.info["HOM"].to_i == 1
				v.info["AF"] = 1.0
				v.pos = v.pos.to_i + chrseq[:len][v.chrom.to_s]
				vars[v.pos] = v.to_s
				hmfile.puts "#{v.pos}"
			end
		else
			warn "No sequnce in fasta file for\t#{v.chrom.to_s}\n"
		end
	end
end

hmfile.close
htfile.close
snpfile.close

@random = SimpleRandom.new
FileUtils.mkdir_p "outseq_lengths"

for iteration in 1..iterations
	# generate an array of random numbers using mean and sample number provided
	# exponential distribution is used
	@random.set_seed

	time1 = Time.now
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

	# create a new folder for current iteration
	# and open a file to write discarded seqeunces with 50% or more ambigous nucleotides
	newname = "genome_" + iteration.to_s
	FileUtils.mkdir_p "#{newname}"
	disfrags = ''
	if @discard_n
		disfrags = File.open("#{newname}/discarded_fragments.fasta", 'w')
	end

	time2 = Time.now
	warn "#{time2 - time1}\n"
	# chromosme sequences are fragemened to the sizes in random number array
	# and saved to a hash
	frags = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
	name_index = 1
	len_start = 1
	chrseq[:seq].keys.sort.each do | id |
		seq = chrseq[:seq][id].dup
		while seq.length > 500
			if seq.length < 1000
				sequence = seq.slice!(0..-1)
				frags,len_start = splice_sequence(sequence, name_index, len_start, frags, disfrags)
			else
				index = number_array.shift.to_i
				sequence = seq.slice!(0...index)
				frags,len_start = splice_sequence(sequence, name_index, len_start, frags, disfrags)
			end
			name_index += 1
		end
	end

	# copy vcf and variant location file to iteration folder
	%x[cp hm_snps.txt #{newname}/hm_snps.txt]
	%x[cp ht_snps.txt #{newname}/ht_snps.txt]
	%x[cp snps.vcf #{newname}/snps.vcf]

	time3 = Time.now
	warn "#{time3 - time2}\n"
	snpvcf = File.open("#{newname}/snps.vcf", 'a')
	current_frag = 1
	vars.keys.sort.each do | position |
		while current_frag < name_index
			limits = frags[:len][current_frag].split(':')
			if position.between?(limits[0].to_i, limits[1].to_i)
				vcfinfo = Bio::DB::Vcf.new(vars[position])
				vcfinfo.chrom = "seq_id_" + current_frag.to_s
				vcfinfo.pos = vcfinfo.pos.to_i - limits[0].to_i
				snpvcf.puts "#{vcfinfo}"
				break
			end
			current_frag += 1
		end
	end

	time4 = Time.now
	warn "#{time4 - time3}\n"
	# write ordered and shuffled fragments for current iteration
	write_fasta(frags[:seq], frags[:seq].keys.sort, "#{newname}/frags_ordered.fasta")

	shuffled = frags[:seq].keys.shuffle(random: Random.new_seed)
	write_fasta(frags[:seq], shuffled, "#{newname}/frags_shuffled.fasta")

	output = File.open("outseq_lengths/#{newname}_lengths.txt", 'w')
	output.puts "fragment_id\tlength"
	Bio::FastaFormat.open("#{newname}/frags_shuffled.fasta").each do |i|
    	output.puts "#{i.entry_id}\t#{i.length}"
	end

	warn "sequences fragment iteration:\t#{iteration}\n"

end
