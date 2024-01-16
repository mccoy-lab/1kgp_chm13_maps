#!/bin/bash
#SBATCH --time=18:00:00                     
#SBATCH --nodes=1                          
#SBATCH --cpus-per-task=48                  
#SBATCH --partition=bigmem
#SBATCH -A mschatz1_bigmem

ml anaconda 
conda activate my-pyrho-env

pop_info=$(sed "${SLURM_ARRAY_TASK_ID}q;d" chrX_nPAR_make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`
n=`cut -f2 -d' '<<<${pop_info}`

pyrho hyperparam --samplesize ${n} --tablefile lookup_tables_nPAR/${pop}_nPAR_lookuptable.hdf \
--mu 1.25e-8 --logfile logs/hyperparam/${pop}_hyperparam.log --ploidy 2 \
--smcpp_file smcpp_popsizes_1kg_nPAR/${pop}_pop_sizes_nPAR.csv --outfile hyperparam_results/${pop}_hyperparam_results_nPAR.txt \
--numthreads 48
