require 'bio'
require 'bio-samtools'
require 'fileutils'

# take mutant position in the whole genome and mark the fragment
# in the current random fragmenting iteration of genome
mutant_posn = ARGV[0].to_i

# change to directory to scan all iterataions folders
Dir.chdir(ARGV[1])
FileUtils.mkdir_p "vars_infrags"
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
			warn "#{folder}\tfragment with mutation\t#{i.entry_id}\n"
		end
		cumulative += i.length.to_i
	end

	# read variants vcf file and count number of variants for each fragment
	vars = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }
	File.open("snps.vcf", "r").each do |line|
		next if line =~ /^#/
		v = Bio::DB::Vcf.new(line)
		if v.info["HET"].to_i == 1
			if vars[:ht].key?(v.chrom.to_s)
				vars[:ht][v.chrom.to_s] += 1
			else
				vars[:ht][v.chrom.to_s] = 1
			end
		elsif v.info["HOM"].to_i == 1
			if vars[:hm].key?(v.chrom.to_s)
				vars[:hm][v.chrom.to_s] += 1
			else
				vars[:hm][v.chrom.to_s] = 1
			end
		end
	end

	output = File.open("../vars_infrags/#{folder}_varinfo.txt", "w")
	output.puts "fragment\tlength\tnumhm\tnumht"
	# go through each sequence and print lenght and number of vars (homozygous and heterozygous)
	seq_ids = seqs.keys.sort_by{ |m| m.scan(/d+/)[0].to_i }
	seq_ids.each do | seqid |
		hm = 0
		hm = vars[:hm][seqid.to_s] if vars[:hm].key?(seqid.to_s)

		ht = 0
		ht = vars[:ht][seqid.to_s] if vars[:ht].key?(seqid.to_s)

		output.puts "#{seqid}\t#{seqs[seqid]}\t#{hm}\t#{ht}"
	end
	output.close
	Dir.chdir('../')
end
