#!/bin/bash
#SBATCH -p tsl-medium
#SBATCH -n 1 # number of cores
#SBATCH --mem 4096 # memory pool for all cores
#SBATCH -t 2-00:00 # time (D-HH:MM)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=rallapag@nbi.ac.uk # send-to address

