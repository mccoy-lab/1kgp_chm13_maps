#!/bin/bash

for i in $(ls lifted_over_A_C) 
do
	gt=$(echo ${i} | cut -f1 -d'_')
	n_gt=$(cat lifted_over_A_C/${i} | wc -l)
	for j in $(ls ../pyrho_1kgp_chm13_unphased_no_mask/hotspots_compact/*_compact_reformatted.bed)
	do 
		pop=$(echo ${j} | cut -f4 -d'/' | cut -f1 -d'_')
		n_overlap=$(bedtools intersect -wa -a lifted_over_A_C/${i} -b  ${j} | wc -l)
		echo $gt $pop $n_overlap $n_gt >> proportion_overlap_A_C.txt
	done
done