### Testing SDM on assembled Arabidopsis genome

#### Assembly

1. De-novo assembly of Single end seqeunce reads for Col-T were used from [Uchida et al] (http://pcp.oxfordjournals.org/content/52/4/716.long) for Uni-1D mutant

2. Genome assembly carried out using SPAdes version: 3.1.0

3. Resulting scaffolds file `uni-1d_col_spades_scaffolds.fasta` and spades log is available under assembly folder

4. A perl script count_fasta.pl is used from [http://wiki.bioinformatics.ucdavis.edu/index.php/Count_fasta.pl](http://wiki.bioinformatics.ucdavis.edu/index.php/Count_fasta.pl) to get sequence lengths and N50 stats

Total length of sequence:	111544374 bp
Total number of sequences:	150004
N25 stats:			25% of total sequence length is contained in the 2987 sequences >= 6349 bp
N50 stats:			50% of total sequence length is contained in the 9054 sequences >= 3423 bp
N75 stats:			75% of total sequence length is contained in the 21629 sequences >= 1401 bp
Total GC count:			40617457 bp
GC %:				36.41 %
 
5. Majority of the assembled sequences were small, so used `select_fasta.rb` script to discard sequences less than 500bp and saved sequnces to `uni-1d_col_spades_scaff_500bp.fasta`

6. 111376 discarded and N50 stats are as following

Total length of sequence:	98441637 bp
Total number of sequences:	38628
N25 stats:			25% of total sequence length is contained in the 2490 sequences >= 6854 bp
N50 stats:			50% of total sequence length is contained in the 7279 sequences >= 3977 bp
N75 stats:			75% of total sequence length is contained in the 15852 sequences >= 2052 bp
Total GC count:			35617429 bp
GC %:				36.18 %


#### SDM analysis

1. `uni-1d_col_spades_scaff_500bp.fasta` is blasted to TAIR10 chromosomes and [blastn output](col_spades500bp_vs_col0.blastn) is converted to gff file using [blastn_to_gff script] (../../../001_blastn_to_gff/blastn-to-GFF_rewrite.rb)

2. [Allen et al](http://journal.frontiersin.org/article/10.3389/fpls.2013.00362/full) backcross read data for both mutant population and parent were used to generate variant vcf files against `uni-1d_col_spades_scaff_500bp.fasta`

3. [samtools_varscan_variants_fg.vcf] (../../002_snps_in_assembled_genome/athal_sdm_test/col-t_sdm_test/sdm_analysis/samtools_varscan_variants_fg.vcf) and [samtools_varscan_variants_bg.vcf] (../../002_snps_in_assembled_genome/athal_sdm_test/col-t_sdm_test/sdm_analysis/samtools_varscan_variants_bg.vcf) are resulting variant files for mutant and parent seqeunce read analysis

4. [filter_vcf_background.rb] (../../../lib/filter_vcf_background.rb) script was used to filter parental snps

5. [blastn_gff_to_ordered_fasta.rb] (../../002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/blastn_gff_to_ordered_fasta.rb) script was used to generate ordered scaffolds sequences `uni-1d_col_spades_scaff_500bp_order.fasta` 

6. [ordered_fasta_vcf_positions.rb] (../../002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/ordered_fasta_vcf_positions.rb) script was used generate necessary order variant positions and vcf file for sdm method input `hm_snps.txt`, `ht_snps.txt` and `snps.vcf`



