pop_number=${SLURM_ARRAY_TASK_ID}

pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

bedtools intersect -v -a chrX_female_vcfs_NEW/${pop}_chrX_female.vcf.gz -b chm13v2.0_PAR.bed -header | bgzip -c > chrX_female_nPAR/${pop}_chrX_female_nPAR_masked.vcf.gz --threads 24

bedtools intersect -v -a chrX_male_vcfs_NEW/${pop}_chrX_male.vcf.gz -b chm13v2.0_PAR.bed -header | bgzip -c > chrX_male_nPAR/${pop}_chrX_male_nPAR_masked.vcf.gz --threads 24
