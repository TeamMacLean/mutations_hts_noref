#!/bin/bash
#SBATCH -p tsl-long
#SBATCH -n 1 # number of tasks
#SBATCH --mem 16384 # memory per node
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=rallapag@nbi.ac.uk # send-to address

# --mem 65536 # memory per node
