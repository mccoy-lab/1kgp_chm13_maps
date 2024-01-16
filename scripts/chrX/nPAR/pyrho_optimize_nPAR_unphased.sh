#!/bin/bash
#SBATCH --time=4:30:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=48
#SBATCH --partition=defq
#SBATCH --account=rmccoy22

ml anaconda 
conda activate my-pyrho-env

pop_number=${SLURM_ARRAY_TASK_ID}
pop_info=$(sed "${pop_number}q;d" chrX_nPAR_make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`


window_size=`grep -h L2 optimize_paramaters/${pop}_optimize_params_nPAR.txt | cut -f2 -d' '`
block_penalty=`grep -h L2 optimize_paramaters/${pop}_optimize_params_nPAR.txt | cut -f1 -d' '`

pyrho optimize --tablefile lookup_tables_nPAR/${pop}_nPAR_lookuptable.hdf --windowsize ${window_size} --blockpenalty ${block_penalty} --vcffile finalVcf/${pop}_chrX_nPar.vcf --outfile opt_params_masked/${pop}_chrX_w${window_size}_b${block_penalty}_masked.rmap --ploidy 2 --numthreads 48 --logfile logs/opt_params_masked/${pop}_chrX_w${window_size}_b${block_penalty}_masked.log
