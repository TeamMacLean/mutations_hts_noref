### Table of Cotents
1. [September 1 - 4](#september-1st-to-4th)
2. [September 7 - 11](#september-7th-to-11th)
3. [September 14 - 18](#september-14th-to-18th)


## September 1st to 4th

1. SNP variants were called for target bulk and parent using Pacbio Ler-1 assembly and Ler-1 from 1001 genomes

2. Parental snps were subtracted from target variants using [filter_vcf_background.rb] (002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/filter_vcf_background.rb) script

3. To test the code running of `SNP_distribution_method` used previously tested data were taken from [Pilar's repo](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere/100kb_contigs/bcf2_nocen_chr3_100kb)

4. Check results in `002_snps_in_assembled_genome/athal_sdm_test/reproduce_test_set` folder



## September 7th to 11th

1. In current state `SNP_distribution_method`, requires both ordered and shuffled sequences as well as variant location in both ordered and shuffled genomes

2. Scripts [blastn_gff_to_ordered_fasta.rb] (002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/blastn_gff_to_ordered_fasta.rb) and [ordered_fasta_vcf_positions.rb] (002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/ordered_fasta_vcf_positions.rb) were used to order sequences for Arabidopsis assemblies and produce variant positions on ordered and shuffled genomes

3. Assemblies used for testing whole genome sorting analysis (both from pacbio and from 1001 genomes) are missing regions of causative muation for Allen et al data. Results of `SNP_distribution_method` are [available at] (002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/sdm_testdata)

4. So to be comparable i have assembled Col-T genome as an independent test set. Single end seqeunce reads for Col-T were used from [Uchida et al] (http://pcp.oxfordjournals.org/content/52/4/716.long) for Uni-1D mutant

5. Genome assembly carried out using SPAdes version: 3.1.0 see [more details at] (002_snps_in_assembled_genome/athal_sdm_test/col-t_sdm_test)

6. SNP calling using Allen et al sequence data on the Col-T assembly and preparation datasets to be suitable for `SNP_distribution_method` was carried out



## September 14th to 18th


