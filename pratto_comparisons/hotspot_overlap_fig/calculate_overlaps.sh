#!/bin/bash

ml bedtools


for thresh in {5,10,50}
do
    filesDir="../hotspots_compact/chm13/${thresh}x"
    files=($(ls "$filesDir"))

    printf "pop1\tpop2\tn.overlap\tn.total\n" > overlaps_${thresh}x.txt

    for i in {0..25}
    do
        for j in $(seq 0 25)
        do
            file1=${files[i]}
            file2=${files[j]}

            pop1=`echo ${file1} | cut -f1 -d'_'`
            pop2=`echo ${file2} | cut -f1 -d'_'`

            n_ol_1=`bedtools intersect -u \
            -wa \
            -a ${filesDir}/${file1} \
            -b ${filesDir}/${file2} | wc -l`

            n_t_1=`wc -l ${filesDir}/${file1} | cut -f1 -d" "`

            n_ol_2=`bedtools intersect -u \
            -wa \
            -a ${filesDir}/${file2} \
            -b ${filesDir}/${file1} | wc -l`

            n_t_2=`wc -l ${filesDir}/${file2} | cut -f1 -d" "`

            n_ol_t=$((n_ol_1 + n_ol_2))
            n_t_t=$((n_t_1 + n_t_2))

            printf "${pop1}\t${pop2}\t${n_ol_t}\t${n_t_t}\n" >> overlaps_${thresh}x.txt
        done
    done
done


