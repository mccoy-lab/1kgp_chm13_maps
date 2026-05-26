#!/bin/bash

ml bedtools

pops=$(ls  hotspots/chm13/10x | cut -f1 -d"_")

printf "All Hotspots\n\n"

printf "5x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > all_overlaps_5x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/5x/${pop}_5x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/5x/${pop}_5x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/5x/${pop}_5x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/5x/${pop}_5x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> all_overlaps_5x.txt
done

printf "10x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > all_overlaps_10x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/10x/${pop}_10x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/10x/${pop}_10x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> all_overlaps_10x.txt
done

printf "50x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > all_overlaps_50x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/50x/${pop}_50x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/50x/${pop}_50x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/50x/${pop}_50x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/50x/${pop}_50x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> all_overlaps_50x.txt
done

printf "100x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > all_overlaps_100x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/100x/${pop}_100x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/100x/${pop}_100x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/all_subtype_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/100x/${pop}_100x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/100x/${pop}_100x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> all_overlaps_100x.txt
done

printf "\nPRDM9 C\n\n"

printf "5x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9c_overlaps_5x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/5x/${pop}_5x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/5x/${pop}_5x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/5x/${pop}_5x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/5x/${pop}_5x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9c_overlaps_5x.txt
done

printf "10x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9c_overlaps_10x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/10x/${pop}_10x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/10x/${pop}_10x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9c_overlaps_10x.txt
done

printf "50x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9c_overlaps_50x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/50x/${pop}_50x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/50x/${pop}_50x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/50x/${pop}_50x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/50x/${pop}_50x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9c_overlaps_50x.txt
done

printf "100x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9c_overlaps_100x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/100x/${pop}_100x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/100x/${pop}_100x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_c_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/100x/${pop}_100x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/100x/${pop}_100x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9c_overlaps_100x.txt
done

printf "\nPRDM9 A/B\n\n"

printf "5x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9ab_overlaps_5x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/5x/${pop}_5x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/5x/${pop}_5x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/5x/${pop}_5x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/5x/${pop}_5x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9ab_overlaps_5x.txt
done

printf "10x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9ab_overlaps_10x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/10x/${pop}_10x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/10x/${pop}_10x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9ab_overlaps_10x.txt
done

printf "50x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9ab_overlaps_50x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/50x/${pop}_50x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/50x/${pop}_50x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/50x/${pop}_50x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/50x/${pop}_50x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9ab_overlaps_50x.txt
done

printf "100x\n\n"

printf "pop\tn_intersect_chm13\tn_intersect_hg38\ttotal_chm13\ttotal_hg38\n" > prdm9ab_overlaps_100x.txt

for pop in ${pops}
do
	n_intersect_chm13=$(bedtools intersect -u -wa -a hotspots_compact/chm13/100x/${pop}_100x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed  | wc -l)

	n_intersect_hg38=$(bedtools intersect -u -wa  -a hotspots_compact/hg38/100x/${pop}_100x_hotspots_compact.bed -b ../sing/prdm9_subtype_peaks/prmd9_ab_peaks.bed | wc -l)
	
	total_chm13=$(cat hotspots_compact/chm13/100x/${pop}_100x_hotspots_compact.bed| wc -l)

	total_hg38=$(cat hotspots_compact/hg38/100x/${pop}_100x_hotspots_compact.bed| wc -l)

	printf "${pop}\t${n_intersect_chm13}\t${n_intersect_hg38}\t${total_chm13}\t${total_hg38}\n" >> prdm9ab_overlaps_100x.txt
done