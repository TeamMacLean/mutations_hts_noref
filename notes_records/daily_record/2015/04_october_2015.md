### Table of Cotents
1. [October 5 - 9]  (#october-5th-to-9th)
2. [October 12 - 16] (#october-12th-to-16th)
3. [October 19 - 23] (#october-19th-to-23rd)
4. [October 26 - 30] (#october-26th-to-30th)


## October 5th to 9th

1. SNP variants were called for published studies of arabidopsis to be used for homozygous to heterozygous ratio distribtuon around the causative muation

2. Details of the datasets are in the following folder [002_snps\_in\_assembled\_genome/contig\_snp\_distribution](../../../002_snps_in_assembled_genome/contig_snp_distribution/)

3. Parent filtered data is being used to model the variant ratio arrangement aroudn the causative mutation

4. Vairnt positions for [allen et al data] (../../../002_snps_in_assembled_genome/contig_snp_distribution/arabidopsis/allen_etal/hsty/) were divided in to chunks of 10kb, 50kb, 100kb, 500kb, 1Mb, 5Mb and 10Mb.

5. polyfitted the homozygous, heterozygous and the ratio between two variants for these genome chunk distributions


## October 12th to 16th

1. Completed polyfit of 4 arabidopsis datasets and produced graphs for each bin size

2. Working towards to define the peak and fit parameters to peak distribution

3. Complete genomes (for example Arabidopsis) contain centromere and telomere, which are repeat rich and host some of the polymorphisms. Using data modelled from whole genome could be different to what we deal with denovo-assembled data. so working towards fitting distribtuion using both whole genome and assemblable part of the genome

4. Whole genome (ordered from Chromosome 1 to 5) and specific chromosome carrying mutation data is used to generate density distribution and curve fitted

5. In addtion to whole genome, assemblable part of whole genome and individual chromosome region covering variant density distrubtion are plotted

6. Variants covering the sizes of 2.5, 5, 10, 25 and 50 Mb around the causative mutation are plotted using whole genome variant data (not limited to chromosome)


## October 19th to 23rd

1. Assemblabe part of the whole genome and individual chormosome data harbouring the causative mutation is binned and plots are generated

2. Variants data in 10Mb and 25Mb around the causative mutation in bins of 500kb is used to curve fit using polynomial model (3rd order or 4th order and above degrees have fit the density distribtuion with R^2 value of 0.7 for sup1 and sup2 data)

3. From the distribtuion it appears that back-cross data set (hsty - allen et al) of the 4 arabidopsis dataset studies is less ideal for snp density distribution based mutation identification.

4. Frequency of mutation induced by EMS(ethyl methyl sulfonate) appears to be one every 110 kb (for arabidopsis), therefore we would end up with ~1100 mutations in genome. From Allen et al hsty backcross data has resulted in 6000 snps, which seem to be insufficient to arrange contigs to pick the key regions.

5. Quantchem r library is used to scan a range of model fits for 4 ararbidopsis data sets. Mostly 4th order polynomial or weighted 4th order polynomial seems to be a good fit.

6. Resulting model equations can be used to reverse predict the approximate disatnce between variants (there by contigs) in the snp density based arrangement


## October 26th to 30th

1. Binning data using contig lengths shows many peaks over varying distances. Such a distribtuion has not given distinct peaks as binning data to different lengths.

2. Box plots of pacbio read lengths and arabidopsis assembly contig length shows that assembly contig lengths are higher. Indicating that above peak distribution using assembly lenghts or pacbio read lengths may not provide a distinct peak region.

3. A pacbio read assembly may be better than pacbio reads and illumina assemblies. test pacbio assembly distribtuion.

4. Previous attempts using arabidopsis assemblies to pick causative mutation has not been successful. So Arabidopsis genome is fragmented using fragments sizes of exponential distribtuon with mean of 11kb. this is to test if the assemblies have caused more errors in limiting identification of mutation.

5. Assemblies distribution is found to fit log-normal distribtuon more than exponential and powerlaw. so have generated random fragments with log-normal paramaters from current assemblies

6. Density plot of the variant distributions along chromosome or genome for whole ordered genome or assembly data is changed to bar charts to get better view of the variant distributions

