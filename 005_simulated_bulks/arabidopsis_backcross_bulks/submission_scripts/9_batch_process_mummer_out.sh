#!/bin/bash

reference="/usr/users/sl/rallapag/blastsets/TAIR10/bwa-index/TAIR10_gDNA.fas"
currdir=$PWD
echo "${currdir}"
for i in {1..20};
do
  echo "iteration num $i"
  cd "${currdir}/bulk_pop_${i}/sim_reps_soap_out/variants/cheripic_out"
  echo "${currdir}/bulk_pop_${i}/sim_reps_soap_out/variants/cheripic_out"
  for k in {1..10};
  do
    types="bam vcf"
    for type in $types
    do
      echo "replicate num $k"
      cd ${type}_mummer_${k}
      infile="ref_vs_selected_${type}_${k}.delta"
      outfile="ref_vs_selected_${type}_${k}.filter"
      tag="image_${type}_${k}"
      # echo "replicate is $k $type $infile $outfile $tag"
      source mummer-3.23_64bit; delta-filter -q -r $infile > $outfile;
      source mummer-3.23_64bit; mummerplot $outfile -p $tag -f -l --large --png -R $reference;
      cd ../
    done
  done
done

