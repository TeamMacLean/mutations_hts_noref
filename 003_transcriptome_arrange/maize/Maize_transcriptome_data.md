### Bulked RNA-seq data analysis using Maize ems data

RNA-seq data published from [Liu et al PlosOne 2012] (http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0036406)
is used for the analysis.

RNA-seq data generated using bulks of maize *glossy* mutant and wildtype phenotyped plants.
A heterozygous plant resulting from a cross between gl3 in non-B73 bacground and an inbread B73 is used to self resulting in segrigating F2 population.

Mutation is recessive

The lower leaves of 32 mutants and 31 non-mutant siblings were collected made pools for sequencing.
The libraries were sequenced on an Illumina GA II resulting in 75 bp single end reads [GenBank accession no. SRA049037] (http://www.ncbi.nlm.nih.gov/sra/?term=SRP010139)

RNA-seq data is quality checked using fastqc 

Fastqc reports of raw data is in the [fastqc_reports folder](./fastqc_reports)[SRR396616](http://htmlpreview.github.io/?./fastqc_reports/SRR396616_fastqc.html)

[SRR396617](http://htmlpreview.github.io/?./fastqc_reports/SRR396617_fastqc.html)

Trimmomatic is used to quality filter reads for adapter and poor base qualities.

Fastqc reports of trimmomatic data is provided in [fastqc_reports folder](./fastqc_reports)

Trimmomatic quality filtered data is used to assemble transcriptome of maize using both bulk samples together.

Assembly carried out using both trinity (v 2.0.6) and soapdenovo-trans (v 1.03).

Assembly with trinity is done with single k-mer set at size 25
With soapdenovo-trans multiple kmer sizes of 25, 31, 41, 51 and 61 and assemblies are pooled from all kmer assemblies. Reduced redundancy using cd-hit-est program.
cd-hit-est was ran with sequence identity threshold (-c) of 0.95
Resulting sequences were further filtered by discarding sequences smaller than 200bp.

Assemblies of Trinity and soapdenovo-trans was compared along with cd-hit-est reduced trinity assembly using detonate software (v1.8.1).

trinity assembly default params score

```
Score   -647646690.57
BIC_penalty     -283004.92
Prior_score_on_contig_lengths   -283895.69
Prior_score_on_contig_sequences -27964329.85
Data_likelihood_in_log_space_without_correction -619258263.77
Correction_term -142803.65
Number_of_contigs       33563
Expected_number_of_aligned_reads_given_the_data 17839700.86
Number_of_contigs_smaller_than_expected_read/fragment_length    0
Number_of_contigs_with_no_read_aligned_to       115
Maximum_data_likelihood_in_log_space    -619150878.48
Number_of_alignable_reads       18095936
Number_of_alignments_in_total   28593577
Transcript_length_distribution_related_factors  -193190.28
```


trinity cdhit reduced assembly score

```
Score   -649246969.54
BIC_penalty     -246958.97
Prior_score_on_contig_lengths   -231053.68
Prior_score_on_contig_sequences -23939391.92
Data_likelihood_in_log_space_without_correction -624927918.38
Correction_term -98353.41
Number_of_contigs       29288
Expected_number_of_aligned_reads_given_the_data 17779048.32
Number_of_contigs_smaller_than_expected_read/fragment_length    0
Number_of_contigs_with_no_read_aligned_to       43
Maximum_data_likelihood_in_log_space    -624821893.47
Number_of_alignable_reads       18046487
Number_of_alignments_in_total   23344722
Transcript_length_distribution_related_factors  -174424.07
```

soapdenovo-trans assembly score

```
Score   -698053392.88
BIC_penalty     -248788.67
Prior_score_on_contig_lengths   -225240.88
Prior_score_on_contig_sequences -17817678.21
Data_likelihood_in_log_space_without_correction -679835760.71
Correction_term -74075.60
Number_of_contigs       29505
Expected_number_of_aligned_reads_given_the_data 16519932.99
Number_of_contigs_smaller_than_expected_read/fragment_length    0
Number_of_contigs_with_no_read_aligned_to       56
Maximum_data_likelihood_in_log_space    -679598364.13
Number_of_alignable_reads       16755935
Number_of_alignments_in_total   23624962
Transcript_length_distribution_related_factors  -182853.49
```

cutadapt was used to trim adapters and remove low quality reads

fastqc reports of the cutadapt resulting reads are available at .....

