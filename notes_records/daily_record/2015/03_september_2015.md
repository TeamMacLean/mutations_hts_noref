### Table of Cotents
1. [September 1 - 4](#september-1st-to-4th)
2. [September 7 - 11](#september-7th-to-11th)
3. [September 14 - 18](#september-14th-to-18th)
4. [September 21 - 25](#september-21st-to-25th)
5. [September 28 - 02](#september-28th-to-2nd-october)


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

1. Reads used for assembly from Uchida et al are of poor quality and the resulting assembly have lot of errors.

2. Vairant calling using poor assembly has resulted in a contig harbouring causative mutation with additional variants resulting due to insertion and deletion from poory assembly

3. Causative mutation in Allen et al data is located on Chr3 at 1405085. Parent filtered variant for contig covering this position in Col-T assembly is as follows

		NODE_2074_length_7366_cov_2.33087_ID_4147	24	.	A	T	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	34	.	G	A	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	42	.	T	G	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	55	.	A	T	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	78	.	A	G	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	91	.	G	A	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	109	.	G	C	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	132	.	G	A	.	PASS	HET=1;HOM=0
		NODE_2074_length_7366_cov_2.33087_ID_4147	4424	.	C	T	.	PASS	HET=0;HOM=1
		
4. variant at position 4424 on `NODE_2074_length_7366_cov_2.33087_ID_4147` is the causative mutation but remaining variants are result of poor assembly

5. Sequence read data from Uchida et al is not of good quality so has resulted in poor assembly 

6. In addition 1001 genome Col-0 sequence reads were also checked and discarded from down stream due to poor quality of readas

7. Re-started assembly using Allen et al mir159a parent data

8. SDM code adaption for whole genome analysis has started


## September 21st to 25th

1. mir159a read assmebly was used for SDM analysis and results are available at [002\_snps\_in\_assembled\_genome/athal\_sdm\_test/allen\_etal\_assembly] (002_snps_in_assembled_genome/athal_sdm_test/allen_etal_assembly)

2. Causative mutation is located on scaffold `NODE_96_length_155806_cov_17.6262_ID_446058` at position 121664

3. variant calls for this scaffold using parent data

		NODE_96_length_155806_cov_17.6262_ID_446058	84	.	T	A	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	327	.	A	T	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	330	.	G	C	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	339	.	A	G	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	87156	.	T	G	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	87171	.	C	A	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	87174	.	C	G	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	123099	.	G	T	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	155642	.	G	A	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	155749	.	T	A	.	PASS	HET=1;HOM=0


4. variant calls for this scaffold using mutant data

		NODE_96_length_155806_cov_17.6262_ID_446058	327	.	A	T	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	330	.	G	C	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	339	.	A	G	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	87156	.	T	G	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	87171	.	C	A	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	87174	.	C	G	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	121664	.	G	A	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	123099	.	G	T	.	PASS	HET=0;HOM=1
		NODE_96_length_155806_cov_17.6262_ID_446058	155749	.	T	A	.	PASS	HET=1;HOM=0
		NODE_96_length_155806_cov_17.6262_ID_446058	155776	.	A	T	.	PASS	HET=1;HOM=0

5. There are still variants at the ends of contig (and all of them are heterozygous) and this also holds with previous Col-T assembly using Uchida et al read data

6. So decided to remove variants from end of the contig which fall with in the length of reads used in assembly

7. [filter\_vcf\_background.rb] (002_snps_in_assembled_genome/athal_sdm_test/pacler_sdm_test/filter_vcf_background.rb) script is modified to implement this change

## September 28th to 2nd October

1. SDM results for Allen et al mir159a reads as assembly and allen et al mir159a and pool of mutation reads for snp densityf distribution have not picked the causative mutation containing scaffold using zero threshold on SDM.

2. Changing threshold to 10, 20 either hasn't picked the scaffold

3. It appears that current version of SDM performance is limited to variant data arrangment with in a chromosome. SDM needs modifications to address this issue

4. Towards this i have started to work on SDM code to apply whole genome analysis

5. I want to derive a model using the homozygous to hetrozygous mutation ratio density around causative muation using published data sets. Such a model would help us in placing the scaffolds with a approximated distances using gaps.

6. Distrubtion from the arabidopsis studies are used for preliminary studies

7. Additional datasets from rice and drosophila were also being included
