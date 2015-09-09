### Running code on previous test data sets

#### Dataset

1. Previous tested data were taken from [Pilar's repo](https://github.com/pilarcormo/SNP_distribution_method/tree/master/arabidopsis_datasets/No_centromere/100kb_contigs/bcf2_nocen_chr3_100kb)

2. SNP distribution method was run using [SNP\_distribution\_method_variation.rb script] (https://github.com/pilarcormo/SNP_distribution_method)

3. Running on hpc

`source ruby-2.0.0; xvfb-run ruby SNP_distribution_method_variation.rb reproduce_test_set test_outcome_thres0 0 1 back`

4. xvfb is used to capture png