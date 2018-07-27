#!/bin/bash

reference="/usr/users/sl/rallapag/blastsets/TAIR10/bwa-index/TAIR10_gDNA.fas"
script="/usr/users/sl/rallapag/scratch/simulations_bulk_allen/write_selected_fasta_file.rb"
currdir=$PWD
echo "${currdir}"
for i in {1..20};
do
  echo "iteration num $i"
  cd "${currdir}/bulk_pop_${i}/sim_reps_soap_out/variants/cheripic_out"
  echo "${currdir}/bulk_pop_${i}/sim_reps_soap_out/variants/cheripic_out"
  for k in {1..10};
  do
    echo "replicate num $k"
    types="bam vcf"
    for type in $types
    do
      mkdir ${type}_mummer_${k}
      cd ${type}_mummer_${k}
      ref="../../../selected_multikmer_sim_rep${k}.scafSeq.fa"
      infile="../${type}_${k}_selected_selected_hme_variants.txt"
      outfile="selected_entries_${type}_${k}.fa"
      # echo "replicate is $k $type $ref $outfile"
      source ruby-2.3.1; ruby ${script} ${infile} ${ref} > ${outfile};
      /usr/users/sl/rallapag/lib/bsub.rb s-2h 12G "source mummer-3.23_64bit; nucmer --prefix=ref_vs_selected_${type}_${k} ${reference} ${outfile}"
      cd ../
    done
  done
done

