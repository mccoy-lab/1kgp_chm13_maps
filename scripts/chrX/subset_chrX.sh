pop_number=${SLURM_ARRAY_TASK_ID}

pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

bcftools view vcf_shapeit5/phased_T2T_panel/1KGP.CHM13v2.0.chrX.recalibrated.snp_indel.pass.phased.vcf.gz -S pop_individuals/${pop}.txt -o chrX_vcfs/${pop}_chrX.vcf.gz --threads 24
