#!/bin/bash
#SBATCH --time=2:00:00                    
#SBATCH --nodes=1                          
#SBATCH --cpus-per-task=48                 
#SBATCH --partition=defq                    
#SBATCH --account=rmccoy22

ml anaconda 
conda activate my-pyrho-env

pop_number=${SLURM_ARRAY_TASK_ID}
pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

window_size=`grep -h L2 ~/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_array/optimize_paramaters/${pop}_optimize_params.txt | cut -f2 -d' '`
block_penalty=`grep -h L2 ~/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_array/optimize_paramaters/${pop}_optimize_params.txt | cut -f1 -d' '`

pyrho optimize --tablefile ~/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_array/lookup_tables/${pop}_lookuptable.hdf --windowsize ${window_size} --blockpenalty ${block_penalty} --vcffile chrX_PAR/${pop}_chrX_PAR_masked.vcf.gz --outfile opt_params_masked/${pop}_chrX_PAR_w${window_size}_b${block_penalty}_masked.rmap --ploidy 2 --numthreads 48 --logfile logs/opt_params_masked/${pop}_chrX_PAR_w${window_size}_b${block_penalty}_masked.log
