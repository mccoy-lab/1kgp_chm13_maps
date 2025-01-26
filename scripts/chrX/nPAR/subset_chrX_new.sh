pop_number=${SLURM_ARRAY_TASK_ID}

pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools view chrX_filtered_HR.vcf.gz -S pop_individuals/${pop}.txt -o chrX_New_byPop_vcfs/${pop}_chrX.vcf.gz --threads 24
