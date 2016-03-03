### Testing SDM on pacbio assembled contig

#### Datasets

1.  From [Allen et al](http://journal.frontiersin.org/article/10.3389/fpls.2013.00362/full) backcross read data was used

2. Sequences for both mutant population and parent are available

3. Pacbio de-novo assembly of [Ler-1](http://datasets.pacb.com.s3.amazonaws.com/2014/Arabidopsis/reads/list.html) as assembled test genome

#### Analysis

1. `mutations_hts_noref/002_snps_in_assembled_genome/athal_sdm_test/Rakefile` outlines the analysis steps

2. Varscan calls of SNPs for mutant[bcf_fg_pacler.vcf] and parent [bcf_bg_pacler.vcf] are generated

3. Since genome used is Ler-1 and the mutants are from Col-0 there are many ecotype specific variants - resulting large vcf files

4. Used `filter_vcf_background.rb` script from lib folder to filter out ecotype specific and parent specific variants and saved them to `filtered_bcf_fg_pacler.vcf`

5. VCF files being large, files are gzipped

6. SDM evaluation mode requires both shuffled and order fasta files as input

7. Variant analysis input `pacbio_ler0_polished_assembly.fasta` and `/002_snps_in_assembled_genome/arabidopsis_assemblies_blast/pacbio_ler0_vs_col0.blastn_to_gff.gff` was used to order contigs from Chromosome 1 to 5, ChrC and ChrM.

8. Current SDM method also requires homozygous (hm) and heterozygous (ht) variant location in completely linear genome and "AF" field in vcf info column

9. Variant hm and ht positons and modified VCF file is generated using `ordered_fasta_vcf_positions.rb` script. Script produces `hm_snps.txt, ht_snps.txt and snps.vcf` required for the SDM method

10. `pacbio_ler0_polished_assembly_sorted.fasta` is renamed as `frags.fasta` and `pacbio_ler0_polished_assembly.fasta` as `frags_shuffled.fasta` as required by SDM method

11. Running on hpc

`source ruby-2.0.0; xvfb-run ruby SNP_distribution_method_variation.rb sdm_testdata pacler_outcome_thres0 0 1 back`
