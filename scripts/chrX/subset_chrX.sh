#!/bin/bash
#SBATCH --time=2:00:00                     
#SBATCH --nodes=1                          
#SBATCH --cpus-per-task=24                 
#SBATCH --partition=defq                    
#SBATCH --account=mschatz1

pop_number=${SLURM_ARRAY_TASK_ID}

pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools view /home/abortvi2/scr16_rmccoy22/abortvi2/vcf_shapeit5/phased_T2T_panel/1KGP.CHM13v2.0.chrX.recalibrated.snp_indel.pass.phased.vcf.gz -S pop_individuals/${pop}.txt -o chrX_vcfs/${pop}_chrX.vcf.gz --threads 24
