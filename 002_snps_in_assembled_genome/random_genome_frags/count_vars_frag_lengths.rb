require 'bio'
require 'bio-samtools'
require 'fileutils'

# take mutant position in the whole genome and mark the fragment
# in the current random fragmenting iteration of genome
mutant_posn = ARGV[0].to_i

# change to directory to scan all iterataions folders
Dir.chdir(ARGV[1])
FileUtils.mkdir_p "vars_frags_lens"
mutfrag = File.open("fragments_with_mut_ids.txt", "w")
mutfrag.puts "#iterations\tfragment"

# subfolders starting with name 'genome' added to array and go through each flder
subfolders = Dir.glob('genome_*').select {|f| File.directory? f}
subfolders.each do | folder |
  Dir.chdir(folder)
  # open a ordered fasta file and store sequence ids and lengths to hash
  cumulative = 0
  seqs = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
  Bio::FastaFormat.open("frags_ordered.fasta").each do |i|
    seqs[i.entry_id] = i.length.to_i
    if mutant_posn.between?(cumulative, cumulative + i.length.to_i)
      mutfrag.puts "#{folder}\t#{i.entry_id}\n"
    end
    cumulative += i.length.to_i
  end

  # read variants vcf file and count number of variants for each fragment
  vars = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
  File.open("snps.vcf", "r").each do |line|
    next if line =~ /^#/
    v = Bio::DB::Vcf.new(line)
    if v.info["HET"].to_i == 1
      if vars[:ht].key?(v.chrom)
        vars[:ht][v.chrom] += 1
      else
        vars[:ht][v.chrom] = 1
      end
      vars[:vars][v.chrom][v.pos.to_i] = 'ht'
    elsif v.info["HOM"].to_i == 1
      if vars[:hm].key?(v.chrom)
        vars[:hm][v.chrom] += 1
      else
        vars[:hm][v.chrom] = 1
      end
      vars[:vars][v.chrom][v.pos.to_i] = 'hm'
    end
  end

  def assign_lengths (hashin, prevstate, start, posn, hashout)
    curr_state = hashin[posn]
    if curr_state == prevstate
      hashout[curr_state] += posn - start
    elsif prevstate == ''
      hashout[curr_state] += posn
    else
      hashout[curr_state] += (posn - start)/2
      hashout[prevstate] += (posn - start)/2
    end
    warn "#{start}\t#{posn}\t#{curr_state}\t#{hashout[curr_state]}\n"
    start = posn
    prevstate = curr_state
    [hashout, prevstate, start]
  end

  varlengths = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
  seq_ids = seqs.keys.sort_by{ |m| m.scan(/d+/)[0].to_i }
  seq_ids.each do | seq_id |
    varlengths[seq_id]['hm'] = 0
    varlengths[seq_id]['ht'] = 0
    start = 0
    prev_state = ''
    number = 0
    numvars = vars[:vars][seq_id].keys.length
    vars[:vars][seq_id].keys.sort.each do | position |
      number += 1
      varlengths[seq_id], prev_state, start = assign_lengths(vars[:vars][seq_id], prev_state, start, position, varlengths[seq_id])
      if number == numvars
        varlengths[seq_id][prev_state] += seqs[seq_id] - start
        start = 0
        prev_state = ''
      end
    end
  end


  output = File.open("../vars_frags_lens/#{folder}_varlengths.txt", "w")
  output.puts "fragment\tlength\thmlen\thtlen\tnumhm\tnumht"
  # go through each sequence and print lenght and number of vars (homozygous and heterozygous)
  seq_ids.each do | seqid |
    hmlen = 0
    htlen = 0
    if varlengths.key?(seqid)
      hmlen = varlengths[seqid]['hm'] if varlengths[seqid].key?('hm')
      htlen = varlengths[seqid]['ht'] if varlengths[seqid].key?('ht')
    end

    hm = 0
    hm = vars[:hm][seqid] if vars[:hm].key?(seqid)

    ht = 0
    ht = vars[:ht][seqid] if vars[:ht].key?(seqid)

    output.puts "#{seqid}\t#{seqs[seqid]}\t#{hmlen}\t#{htlen}\t#{hm}\t#{ht}"
  end
  output.close

  Dir.chdir('../')
end
mutfrag.close
