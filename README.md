# 1KGP T2T-CHM13 Maps

Recombination maps generated using [pyrho](https://github.com/popgenmethods/pyrho) for autosomes and X chromosomes from the Thousand Genomes Project (1KGP), realigned to the [T2T-CHM13 reference genome](https://github.com/marbl/CHM13). 

[Data is available here](https://drive.google.com/drive/folders/1XHpFu_SLAtgF3kZuzRC1WeH5LXtIv4NW?usp=sharing)

Recombination maps have been generated both with and without the use of a [short read accessibility mask](https://github.com/marbl/CHM13). 

Each set of recombination maps is available as a set of population-specific maps and as an averaged map for the entire 1KGP dataset. 

## Inputs

Files necessary for running scripts. 

* `igsr_samples.tsv` - Sample metadata from 1000 Genomes Project site 
* `pop_individuals` - Directory containing a list of individuals from each population in the 1KGP dataset. Used to subset VCF into 26 population-specific VCFs
* `make_table_pop_sizes.txt` - For each population, reports number of chromosomes in the 1KGP dataset and 1.5x this value. Used by pyrho in creation of lookup tables. 
* `pop_sizes.txt` - Same as `make_table_pop_sizes.txt`, except reported by number of individuals (rather than chromosomes). Not used directly by pyrho, but used in some R scripts for weighing populations. 
* `chrX_nPAR_make_table_pop_sizes.txt` - `make_table_pop_sizes` scaled by 0.75, for mapping chrX non-PAR regions 

## Scripts

Separated into scripts used for creation of recombination maps for **autosomes**, **chrX PAR regions**, and **chrX non-PAR regions**. For autosomes, we provide scripts used on phased and unphased datasets. 


### Preprocessing scripts 

* `subset_pops_unrelated.sh` - subset VCF of unrelated individuals by population. 
* `filterChrX.sh` - apply Joe's filtering scheme to X chr
* `getPopSizesNPAR.py` - used to calculate sample size, scaled for nPAR 


### Autosomes

* `make_table_array.sh` - Calculate lookup tables for autosomes (and chrX PAR)
* `hyperparam_array_unphased.sh` - Calculate hyperparameters for each population
* `bedtools_mask_array.sh` - apply accessibility mask to VCFs, prior to recombination map creation
* `pyrho_optimize_unphased.sh` - Use L1 norm maximizing parameters to generation recombination map creation
* `bedtools_mask_rmap_output.sh` - Apply genome mask to pyrho output
* `make_final_mapsUnphased.R` - Reformat masked maps for averaging across populations
* `avgByBase.py` - Average recombination rates across all populations, weighed by number of samples from that population in 1KGP

Misc scripts: 

* `correlate_phased_unphased.R` - Correlate pyrho output with published hg38 maps. Also correlate phased/unphased maps

### X chromosome 

* `subset_chrX.sh` - Split chrX VCF by population
* `mask_chrX.sh` - Apply short read accessibility mask to chrX VCFs

#### PAR 

* `subset_to_PAR.sh` - Subset masked chrX VCF to only include PAR1 and PAR2 
* `pyrho_optimize_unphased_PAR.sh` - Use L1 norm maximizing parameters to generation recombination map creation
* `bedtools_mask_rmap_output_PAR.sh` - Apply short read accessibility mask to pyrho output
* `make_final_mapsUnphased_PAR.R` - Reformat masked maps for averaging across populations
* `avgByBase_PAR.py` - Average recombination rates across all populations, weighed by number of samples from that population in 1KGP
* `subset_avgMap_to_PAR.sh` - Subset recombination map averaged across populations to only inlcude PAR1 and PAR2

#### non-PAR

* `getIndividuals.py` - used for separating males/females for chrX non-PAR phasing
* `getMaleFemaleNames.py` - used for separating males/females for chrX non-PAR phasing
* `rescalePopSize_nPAR.py` -
* `pseudoHapMales.py` - Make pseudohaploid males 
* `make_table_nPAR_array.sh` - Calculate lookup tables for nPAR
* `hyperparam_array_nPar.sh` - Calculate nPAR-specific hyperparameters
* `pyrho_optimize_nPAR_unphased.sh` - Use L1 norm maximizing parameters to generation recombination map creation
* `bedtools_mask_rmap_output_nPAR.sh` - Apply short read accessibility mask to pyrho output
* `make_maps_toAvg_Unphased_nPAR.R` - Reformat masked maps for averaging across populations
* `avgByBase_nPAR.py` - Average recombination rates across all populations, weighed by number of samples from that population in 1KGP
