#!/bin/bash

for i in $(ls lifted_over) 
do
	for j in $(ls ../pyrho_1kgp_chm13_unphased_no_mask/hotspots_compact/*_compact_reformatted.bed)
	do 
		gt=$(echo ${i} | cut -f1 -d'_')
		pop=$(echo ${j} | cut -f4 -d'/' | cut -f1 -d'_')
		n_overlap=$(bedtools intersect -a lifted_over/${i} -b  ${j} | wc -l)
		n_gt=$(cat lifted_over/${i} | wc -l)
		echo $gt $pop $n_overlap $n_gt >> proportion_overlap.txt
	done
done