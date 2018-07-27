#!/bin/bash
# submitting high memory assembly job

mkdir sim_reps_soap_out
for k in {1..10};
do
  echo "iteration is $k"
  dirname=$PWD
  first="wt_${k}_sim_paired_fir.fastq.gz"
  second="wt_${k}_sim_paired_sec.fastq.gz"
  file="sample_rep${k}.config"
  touch $file
  cat > $file <<- EOM
max_rd_len=100
[LIB]
rd_len_cutof=100
avg_ins=250
asm_flags=3
map_len=32
q1=${dirname}/${first}
q2=${dirname}/${second}
EOM
  source soapdenovo2-2.40; SOAPdenovo-127mer all -K 25 -d 1 -R -M 1 -m 95 -E -F -s ${file} -o multikmer_sim_rep${k}
  gzip multikmer_sim_rep${k}.scafSeq
  gzip multikmer_sim_rep${k}.contig
  mv multikmer_sim_rep${k}.scafSeq.gz sim_reps_soap_out
  mv multikmer_sim_rep${k}.contig.gz sim_reps_soap_out
  rm multikmer_sim_rep${k}.*
done

