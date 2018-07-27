#!/bin/bash
# submitting high memory mummer job
#PBS -l select=1:mem=180GB:ncpus=8

# Explicitly change to the job directory
export PBS_JOBDIR=/usr/users/sl/rallapag/scratch/assemblies/barley/soap_multi_k
cd $PBS_JOBDIR

source soapdenovo2-2.40; SOAPdenovo-127mer all -K 25 -d 1 -R -M 1 -m 95 -E -F -s sample.config -o barley_multikmer > assembly_analysis_log.txt

