awk -F '\t' -v OFS='\t' -v chrom="chrX" '{ print chrom,$1,$2,$3,$4 }' averagedByBase/chrX_PAR.txt  | sed 's/[[:space:]]*$//' > averagedByBase/chrX_PAR.bed

bedtools intersect -a averagedByBase/chrX_PAR.bed -b chm13v2.0_PAR.bed > averagedByBase/chrX_PAR_isec.bed

