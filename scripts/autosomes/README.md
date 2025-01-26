# Autosomes

* `make_table_array.sh` - Calculate lookup tables for autosomes (and chrX PAR)
* `hyperparam_array_unphased.sh` - Calculate hyperparameters for each population
* `bedtools_mask_array.sh` - apply accessibility mask to VCFs, prior to recombination map creation
* `pyrho_optimize_unphased.sh` - Use L1 norm maximizing parameters to generation recombination map creation
* `bedtools_mask_rmap_output.sh` - Apply genome mask to pyrho output
* `make_final_mapsUnphased.R` - Reformat masked maps for averaging across populations
* `avgByBase.py` - Average recombination rates across all populations, weighed by number of samples from that population in 1KGP

Misc scripts: 

* `correlate_phased_unphased.R` - Correlate pyrho output with published hg38 maps. Also correlate phased/unphased maps