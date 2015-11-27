### Table of Cotents
1. [November 2 - 6]  (#november-2nd-to-6th)
2. [November 9 - 13]  (#november-9th-to-13th)
3. [November 16 - 20]  (#november-16th-to-20th)
4. [November 23 - 27]  (#november-23rd-to-27th)

## November 2nd to 6th

1. Variants identified from assembly around the causative mutation are plotted with assembly lengths as bins for sup1, sup2, soc1 and hasty.

2. Distribution of ratios around causative mutation using assembly lengths have not shown any clear pattern of primary peaks close to the causative mutation regardless of whether ratios are adjusted for lengths of the assembly or not.

3. In addition to the assembly, random 1000 iterations of arabidopsis genome fragmented with modelled log-normal distribution derived arabidopsis assemblies were generated to test above points independently. variant frequencies are taken from published studies.

4. Smaller number addtiona (such as 0.1 or 0.01 or lower) as ratio adjustment factor seems to increase ratios dramatically, especially for the contigs/ fragments without heterozygous variants. therefore it is preferred to use anything between 1 and 0.5.

5. From 1000 random iterations of hasty mutant data we can see that on average ~620 contigs had variants out of ~12000 fragments. And only ~33 fragments had higher homozygous than heterozygous variatns. This dataset is a backcross mutant data. 

6. Now generating random data from an outcrossed mutant sequencing and would help us determine the limits of the analysis.


## November 9th to 13th

1. Looking at the data from the contigs/fragments with variants, it seems only about 30 MB of genome had information (from the random iterations data)

2. Backcross data from hasty mutant shows two peaks (both normalized and non-normalized ratios using fragment lengths).

3. More mutant data is being processed to generate distributions and derive equations to the distributions. Such equations would help us evaluating final arragements for de-novo data.

4. Arabidopsis sup2 mutant data was used to generate random fragments: Out of ~12000 fragments, ~7800 fragments had variants, while about ~850 fragments had more homozygous than heterozygous variants.

5. With sup2 data from 867 iterations, we see a distinct peak, while for length normalized data various peaks are found.

6. Using data from iterations we could see that length normalization is not requied, as it create more distinct peaks outside the causative mutation region.


## November 16th to 20th

1. I have looked at ratios using near to 500 KB chunks of fragments pooled or 500KB chunks in a sliding window. In both cases we see a clear peak around the causative mutation region. May be this could be used to check the arrangement.

2. Using all the fragments with causative mutation from random iterations, minimum ratio fragments to keep is being decided.

3. From sup2 data analysis, ratio >=5 (when using 0.5 as factor to add) has removed most fragments out side the peak. While hasty data mostly gave (99% iterations) ratio value of 3. So variant frequency should factored in to the cut-off value for fragment ratios.


## November 23rd to 27th

1. working towards cleaning the SNP distribution code for whole genome analysis and update code for complete gem. Made updates to images plotting ratios arranged after SDM and comparison to position in ordered genome

2. updated code to produce qqplots for both homozygous variants from fragments as well as the ratios of homozygous to heterozygous for the fragments.

3. Checking if the causative mutation is enriched in homozygous rich region (length of region hosting homozygous vars to region hosting heterozygous vars). This would help to exclude some fragments.

4. From the iteration analysis (from sup2 data), it shows that 90% of times fragment with mutation is only in the top 4% of fragments ranked based on ratio of homozygous to heterozygous. 85% of iterations have ratio value 5 or more.

5. Linkage grouping softwares from marker could be of help if the individual plant sequencing instead of bulk sequencing is done (have to test how many individual plant sequencing needed to improve the order of contigs).

6. [SNP_distribution_method code] (https://github.com/shyamrallapalli/SNP_distribution_method/tree/debug_wholegenome) is being updated and streamlined to to able make a gem. Lot of code redundancy have been removed and is being updated.