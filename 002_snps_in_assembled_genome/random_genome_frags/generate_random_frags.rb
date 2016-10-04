require 'simple-random'
require 'bio'
require 'bio-samtools'
require 'fileutils'
require 'yaml'

pars = YAML.load_file('frag_pars.yml')

# mean, std deviation and sample size to generate random numbers
# add additonal 10% to sample number to be able to cover the whole genome length
sample = pars['sample']  # 9600 + 500 random numbers (contig number)
distri = pars['distri'] # distribtuion to apply to selecte random number for fragment lengths
mean = pars['mean']   # 11885 bp is mean / 7.889536 is mean of log of lengths
sd = pars['sd']    # 30160 bp is std. deviation / 1.56288 is sd of log of lengths
iter_start = pars['iter_start'] # iteration counter start value
iterations = pars['iterations'] # number of iterations of framenting
@discard_n = pars['discard_n'] # boolean option to discarding sequences with 50% or more 'N's

# a hash of chromosome sequences and accumulated lengths
chrseq = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
Bio::FastaFormat.open(ARGV[0]).each do |inseq|
  chrseq[:seq][inseq.entry_id] = inseq.seq.to_s
  chrseq[:length][inseq.entry_id] = inseq.length
end

genome_length = 0
chrseq[:length].keys.sort.each do | sorted_id |
  chrseq[:len][sorted_id] = genome_length
  genome_length += chrseq[:length][sorted_id]
end

# write fasta frag hash to a file
# array of ids provided either sorted or shuffled
def write_fasta(hash, array, filename)
  outfile = File.open(filename, 'w')
  array.each do | element |
    if hash.key?(element)
      seqout = Bio::Sequence::NA.new(hash[element]).upcase
      outfile.puts seqout.to_fasta("seq_id_#{element}", 80)
    else
      warn "#{element}\tno seq present to write to fasta file\n"
    end
  end
  outfile.close
end

# Input 0: Filename by which to save an array with filetype extension, one value per line
# Input 1: Array to save
def write_array(filename, array)
  File.open(filename, 'w+') do |f|
    array.each { |element| f.puts(element) }
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
      seqout = Bio::Sequence::NA.new(inseq).upcase
      discardsfile.puts seqout.to_fasta("seq_id_#{nameindex}", 80)
      return [fragshash, lenindex]
    end
  end
  fragshash[:seq][nameindex] = inseq
  fragshash[:len][nameindex] = [lenindex, lenindex+seqlen-1].join(':')
  lenindex += seqlen

  [fragshash, lenindex]
end

### an array for vcf header
vcf_header = []

### Read sequence fasta file and store sequences in a hash
vars = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
File.open(ARGV[1], 'r').each do |line|
  if line =~ /^#/
    vcf_header << line
  else
    v = Bio::DB::Vcf.new(line)
    if chrseq[:len].has_key?(v.chrom.to_s)
      if v.info['HET'].to_i == 1
        v.info['AF'] = 0.5
      elsif v.info['HOM'].to_i == 1
        v.info['AF'] = 1.0
      end
      v.pos = v.pos.to_i + chrseq[:len][v.chrom.to_s]
      vars[v.pos] = v.to_s
    else
      warn "No sequnce in fasta file for\t#{v.chrom.to_s}\n"
    end
  end
end

# argument 3 provides the chromosome id and position of causative mutation seperated by ':'
# this is used to get position in the sequential order of the chromosomes
adjust_posn = 0
unless ARGV[2].nil?
  info = ARGV[2].split(/:/)
  adjust_posn = chrseq[:len][info[0].to_s] + info[1].to_i
  warn "adjusted mutation position\t#{adjust_posn}"
end

@random = SimpleRandom.new
FileUtils.mkdir_p 'outseq_lengths'

for iteration in iter_start..(iterations+iter_start-1)
  # generate an array of random numbers using mean and sample number provided
  # exponential distribution is used
  @random.set_seed

  number_array = []
  i = 0
  while i < sample
    if distri == 'exponential'
      number = @random.exponential(mean).to_i
    elsif distri == 'lognormal'
      number = @random.log_normal(mean, sd).to_i
    else
      warn 'no distribution selected'
      break
    end
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
  newname = 'genome_' + iteration.to_s
  FileUtils.mkdir_p "#{newname}"
  disfrags = ''
  if @discard_n
    disfrags = File.open("#{newname}/discarded_fragments.fasta", 'w')
  end

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
      else
        index = number_array.shift.to_i
        sequence = seq.slice!(0...index)
      end
      frags,len_start = splice_sequence(sequence, name_index, len_start, frags, disfrags)
      name_index += 1
    end
  end

  # close discarded frags file if it is used to write ambigous sequences
  unless disfrags == ''
    disfrags.close
  end

  # print vcf header and variant location file to iteration folder
  write_array("#{newname}/snps.vcf", vcf_header)

  snpvcf = File.open("#{newname}/snps.vcf", 'a')
  current_frag = 1
  vars.keys.sort.each do | position |
    while current_frag < name_index
      if frags[:len].key?(current_frag)
        limits = frags[:len][current_frag].split(':')
        if position.between?(limits[0].to_i, limits[1].to_i)
          vcfinfo = Bio::DB::Vcf.new(vars[position])
          vcfinfo.chrom = 'seq_id_' + current_frag.to_s
          vcfinfo.pos = vcfinfo.pos.to_i - limits[0].to_i
          snpvcf.puts "#{vcfinfo}"
          # check if causative mutation is the current position
          # and print new fragment id and position for downstream analysis
          unless adjust_posn == 0
            if position == adjust_posn
              warn "#{iteration}\t#{vcfinfo.chrom}\t#{vcfinfo.pos}\n"
            end
          end
          # now that we found var postion in a fragment
          # break while loop and get next var position
          break
        end
      end
      current_frag += 1
    end
  end
  snpvcf.close

  # write ordered and shuffled fragments for current iteration
  # write_fasta(frags[:seq], frags[:seq].keys.sort, "#{newname}/frags_ordered.fasta")
  order = File.open("#{newname}/frags_ordered.txt", 'w')
  frags[:seq].keys.sort.each do  | key |
    order.puts "seq_id_#{key}"
  end
  order.close

  shuffled = frags[:seq].keys.shuffle(random: Random.new_seed)
  write_fasta(frags[:seq], shuffled, "#{newname}/frags_shuffled.fasta")

  output = File.open("outseq_lengths/#{newname}_lengths.txt", 'w')
  output.puts "fragment_id\tlength"
  Bio::FastaFormat.open("#{newname}/frags_shuffled.fasta").each do |inseq|
      output.puts "#{inseq.entry_id}\t#{inseq.length}"
  end
  output.close
  %x[gzip #{newname}/frags_shuffled.fasta]

  # setting fragmented sequence hash to nil to clear memory
  frags = nil
  # warn "sequences fragment iteration:\t#{iteration}\n"

end
