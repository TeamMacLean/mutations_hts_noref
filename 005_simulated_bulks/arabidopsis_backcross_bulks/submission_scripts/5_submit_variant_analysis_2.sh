#!/bin/bash

currdir=$PWD
rake_file = "/tsl/scratch/rallapag/simulations_bulk_allen/genomes_sim/broken_sim/rakefile_at_sim"
echo "${currdir}"
for i in {1..20};
do
  echo "iteration num $i"
  cd "${currdir}/bulk_pop_${i}/sim_reps_soap_out/"
  echo "${currdir}/bulk_pop_${i}/sim_reps_soap_out/"
  cd variants
  for k in {1..10};
  do
    echo "replicate num $k"
    ref="../selected_multikmer_sim_rep${k}.scafSeq.fa"
    read1="../../wt_${k}_sim_paired_fir.fastq.gz"
    read2="../../wt_${k}_sim_paired_sec.fastq.gz"
    outdir="vars_rep_${k}_wt"
    /usr/users/sl/rallapag/lib/bsub.rb m-2d 12G "source ruby-2.3.1; rake -f ${rake_file} variants:all ref=${ref} r1=${read1} r2=${read2} dir=${outdir} &>> log_rep_${k}_wt.txt"
  done
done
