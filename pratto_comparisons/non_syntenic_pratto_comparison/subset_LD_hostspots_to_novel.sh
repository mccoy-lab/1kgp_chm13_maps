#!/bin/bash

pops=`ls ../hotspots_compact/chm13/10x | cut -f1 -d"_"`

for pop in ${pops}
do
	bedtools intersect -a ../hotspots_compact/chm13/10x/${pop}_10x_hotspots_compact.bed -b ../chm13v2-unique_to_hg38.bed > hotspots_compact_novel_to_chm13/${pop}_hotspots_novel_to_chm13.bed
done