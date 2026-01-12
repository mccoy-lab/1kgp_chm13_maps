pop_number=${SLURM_ARRAY_TASK_ID}

pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

bcftools view chrX_New_vcfs_masked/${pop}_chrX_masked.vcf.gz -S femaleIndividualNames/${pop}_females.txt -o chrX_female_vcfs_NEW/${pop}_chrX_female.vcf.gz --threads 24
