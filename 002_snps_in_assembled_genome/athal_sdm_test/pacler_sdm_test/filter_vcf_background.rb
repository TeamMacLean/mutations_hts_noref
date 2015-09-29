#encoding: utf-8
require 'bio'
require 'bio-samtools'

if ARGV.empty?
   puts "Please specify (1) target vcf file, (2) background vcf file and (3) reference fasta file used for snp calls as arguments in that order"
else
   in_vcf = ARGV[0] # location of target/mutant variants vcf file && output vcf file will be created in the same folder.
   bg_vcf = ARGV[1] # location of parent/background variants vcf file.
   in_ref = ARGV[2] # reference fasta file used to call variants to filter out snps at contig ends
   readlen = ARGV[3].to_i/2 # read length is used decide on the use of contig end variants
end

bg_vars = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) } # a hash of variants from background vcf file
File.open(bg_vcf, 'r').each do |line|
   next if line =~ /^#/
   v = Bio::DB::Vcf.new(line)
   chrom = v.chrom
   pos = v.pos
   info = v.info
   if info["HET"] == "1"
      bg_vars[chrom][pos]["HET"] = 1
   elsif info["HOM"] == "1"
      bg_vars[chrom][pos]["HOM"] = 1
   end
end

sequences  = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) } # a hash of sequence lengths from reference
Bio::FastaFormat.open(in_ref).each do |inseq|
      sequences[inseq.entry_id] = inseq.length
end

location = File.dirname(in_vcf)  # directory path to in_vcf file
new_name = "filtered_" + "#{File.basename(in_vcf)}" # new filename for output vcf file
out_vcf = File.open("#{location}/#{new_name}", 'w+')

File.open(in_vcf, 'r').each do |line2|
   if line2 =~ /^#/
      out_vcf.puts "#{line2}"
   else
      v = Bio::DB::Vcf.new(line2)
      chrom = v.chrom
      pos = v.pos
      info = v.info
      if info["HET"] == "1"
         if bg_vars[chrom][pos].has_key?("HET")
            next
         elsif readlen < pos and pos < (sequences[chrom] - readlen)
            out_vcf.puts "#{line2}"
         end
      elsif info["HOM"] == "1"
         if bg_vars[chrom][pos].has_key?("HOM")
            next
         elsif readlen < pos and pos < (sequences[chrom] - readlen)
            out_vcf.puts "#{line2}"
         end
      end
   end
end
