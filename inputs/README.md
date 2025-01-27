# Inputs

Contains all non-vcf files necessary for recombination map construction. 

* `pop_individual`: Contains one file for each of the 1KGP recombination maps. Each of these files contains the IDs of each individual from the population
* `make_table_pop_sizes.txt`: Number of individuals from each population represented in 1KGP dataset. Necessary for lookup table creation.
* `chrX_nPAR_make_table_pop_sizes`: Number of individuals from each population represented in 1KGP dataset **scaled by 0.75**. Necessary for lookup table creation.
* `igsr_samples.tsv`: 1KGP metadata table provided by IGSR
* `smcpp_popsizes_1kg`: Inferred historical population sizes inferred by [smc++](https://github.com/popgenmethods/smcpp). Data adapted from [here](https://github.com/popgenmethods/pyrho/blob/master/smcpp_popsizes_1kg.csv) - csv split into multiple files and years column converted to generations. 
