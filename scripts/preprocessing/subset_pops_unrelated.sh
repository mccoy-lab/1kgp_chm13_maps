pop_number=$(( (${SLURM_ARRAY_TASK_ID} + 22 -1) / 22 )) 
chr=$(( ${SLURM_ARRAY_TASK_ID} % 22 ))
if [ ${chr} -eq 0 ]
then
  chr=22
fi

pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`

bcftools view /home/abortvi2/scr16_rmccoy22/abortvi2/vcf_shapeit5/phased_T2T_panel/1KGP.CHM13v2.0.chr${chr}.recalibrated.snp_indel.pass.phased.vcf.gz -S pop_individuals/${pop}.txt -o unrelated/${pop}_chr${chr}.vcf.gz --threads 24
