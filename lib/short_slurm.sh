#!/bin/bash
#SBATCH -p tsl-short
#SBATCH -n 1 # number of cores
#SBATCH --mem 2048 # memory pool per node
#SBATCH -t 0-06:00 # time (D-HH:MM)
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=rallapag@nbi.ac.uk # send-to address

