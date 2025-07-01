ml bedtools
ml htslib

pop_number=$(( (${SLURM_ARRAY_TASK_ID} + 22 - 1) / 22 )) 
pop_info=$(sed "${pop_number}q;d" make_table_pop_sizes.txt)
pop=`cut -f1 -d' '<<<${pop_info}`
chr=$(( ${SLURM_ARRAY_TASK_ID} % 22 ))
if [ ${chr} -eq 0 ]
then
  chr=22
fi

bedtools intersect -a unrelated/${pop}_chr${chr}.vcf.gz -b combined_mask.bed.gz -header | bgzip -c > unrelated_masked/${pop}_chr${chr}_masked.vcf.gz
