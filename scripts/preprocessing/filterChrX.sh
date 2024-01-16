#!/bin/bash

export BCFTOOLS_PLUGINS=/home/abortvi2/scr4_rmccoy22/abortvi2/bcftools-1.14/plugins

ref_fasta="/home/abortvi2/data_rmccoy22/resources/references/T2T-CHM13v2.0/chm13v2.0.fasta"
input_vcf="1KGP.CHM13v2.0.chrX.recalibrated.snp_indel.pass.vcf.gz"
mendelian_pedigree="trios_only.ped"
population_ids="unrelated_superpopulations.csv"
vcf_to_phase="chrX_filtered.vcf.gz"

~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools norm --threads 40 -Ou -f $ref_fasta -m- $input_vcf \
| ~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools +mendelian -Ou - --ped $mendelian_pedigree -m a -m d \
| ~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools +fill-tags --threads 40 -Ou - -- -t AN,AC \
| ~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools +fill-tags --threads 40 -Ou - -- -S $population_ids -t HWE \
| ~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools view -e "ALT=='*' || INFO/NEGATIVE_TRAIN_SITE || INFO/VQSLOD<0 || F_MISSING>0.05 || INFO/MERR>30 || MAC==0 || INFO/HWE_EUR<1e-10 || INFO/HWE_AFR<1e-10 || INFO/HWE_EAS<1e-10 || INFO/HWE_AMR<1e-10 || INFO/HWE_SAS<1e-10 || FILTER!='PASS'" --threads 40 -Ou - \
| ~/scr4_rmccoy22/abortvi2/bcftools-1.14/bcftools annotate -Ob -x ^INFO/AC,^INFO/AN,^FORMAT/GT,^FORMAT/PS > $vcf_to_phase 
