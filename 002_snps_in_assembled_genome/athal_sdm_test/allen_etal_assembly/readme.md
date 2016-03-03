### Testing SDM on assembled Arabidopsis genome

#### Assembly

1. De-novo assembly of paired end seqeunce reads for mir159a were used from  [Allen et al](http://journal.frontiersin.org/article/10.3389/fpls.2013.00362/full)

2. Genome assembly carried out using SPAdes version: 3.6.0

3. Resulting scaffolds file `allen_bg_spades3.6_scaff.fasta` and spades log is available under assembly folder

4. count_fasta.pl output of sequence lengths and N50 stats

		Total length of sequence:	124753515 bp
		Total number of sequences:	119323
		N25 stats:			25% of total sequence length is contained in the 174 sequences >= 115281 bp
		N50 stats:			50% of total sequence length is contained in the 580 sequences >= 52756 bp
		N75 stats:			75% of total sequence length is contained in the 1642 sequences >= 15827 bp
		Total GC count:			45440973 bp
		GC %:				36.42 %

 
5. `select_fasta.rb` script used to discard sequences less than 500bp and saved sequnces to `allen_bg_spades3.6_scaff_500bp.fasta`

6. 109713 discarded and N50 stats for `allen_bg_spades3.6_scaff_500bp.fasta` are as following

		Total length of sequence:	114215436 bp
		Total number of sequences:	9610
		N25 stats:			25% of total sequence length is contained in the 152 sequences >= 122984 bp
		N50 stats:			50% of total sequence length is contained in the 486 sequences >= 59069 bp
		N75 stats:			75% of total sequence length is contained in the 1239 sequences >= 23704 bp
		Total GC count:			41231984 bp
		GC %:				36.10 %


#### SDM analysis

1. `allen_bg_spades3.6_scaff_500bp.fasta ` is blasted to TAIR10 chromosomes and `allen_bg_spades3.6_vs_col0.blastn` is converted to gff file using [blastn\_to_gff script] (../../../001_blastn_to_gff/blastn-to-GFF_rewrite.rb)

2. [Allen et al](http://journal.frontiersin.org/article/10.3389/fpls.2013.00362/full) backcross read data for both mutant population and parent were used to generate variant vcf files against `allen_bg_spades3.6_scaff_500bp.fasta`

3. [samtools\_varscan\_variants_fg.vcf] (../../002_snps_in_assembled_genome/athal_sdm_test/allen_etal_assembly/samtools_varscan_variants_fg.vcf) and [samtools\_varscan\_variants_bg.vcf] (../../002_snps_in_assembled_genome/athal_sdm_test/allen_etal_assembly/samtools_varscan_variants_bg.vcf) are resulting variant files for mutant and parent seqeunce read analysis

4. [filter_vcf_background.rb] (../../../lib/filter_vcf_background.rb) script was used to filter parental snps and snps at the end of contigs

5. [blastn_gff_to_ordered_fasta.rb] (../../002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/blastn_gff_to_ordered_fasta.rb) script was used to generate ordered scaffolds sequences `uni-1d_col_spades_scaff_500bp_order.fasta` 

6. [ordered_fasta_vcf_positions.rb] (../../002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/ordered_fasta_vcf_positions.rb) script was used generate necessary order variant positions and vcf file for sdm method input `hm_snps.txt`, `ht_snps.txt` and `snps.vcf`


