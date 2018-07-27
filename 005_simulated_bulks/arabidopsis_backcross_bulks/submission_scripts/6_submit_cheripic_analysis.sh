#!/bin/bash

currdir=$PWD
echo "${currdir}"
for i in {1..20};
do
  echo "iteration num $i"
  cd "${currdir}/bulk_pop_${i}/sim_reps_soap_out/variants/"
  echo "${currdir}/bulk_pop_${i}/sim_reps_soap_out/variants/"
  mkdir cheripic_out
  cd cheripic_out
  for k in {1..10};
  do
    echo "replicate num $k"
    ref="../../selected_multikmer_sim_rep${k}.scafSeq.fa"
    mutvcf="../vars_rep_${k}_mutant/samtools_varscan_variants.vcf"
    bgvcf="../vars_rep_${k}_wt/samtools_varscan_variants.vcf"
    mutbam="../vars_rep_${k}_mutant/align_paired_sorted.bam"
    bgbam="../vars_rep_${k}_wt/align_paired_sorted.bam"
    cheripic="/usr/users/sl/rallapag/lib/cheripic-1.2.6-linux-x86_64/cheripic"
    /usr/users/sl/rallapag/lib/bsub.rb m-2d 12G "${cheripic} --input-format bam -f ${ref} --mut-bulk ${mutbam} --bg-bulk ${bgbam} --mut-bulk-vcf ${mutvcf} --bg-bulk-vcf ${bgvcf} --output bam_${k}_selected --max-d-multiple 0 --maxdepth=105"
    /usr/users/sl/rallapag/lib/bsub.rb s 4G "${cheripic} --input-format vcf -f ${ref} --mut-bulk ${mutvcf} --bg-bulk ${bgvcf} --output vcf_${k}_selected --max-d-multiple 0 --maxdepth=105"
  done
done

