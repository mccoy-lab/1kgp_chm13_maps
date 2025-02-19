# 1KGP T2T-CHM13 Maps

Recombination maps generated using [pyrho](https://github.com/popgenmethods/pyrho) for autosomes and X chromosomes from the Thousand Genomes Project (1KGP), realigned to the [T2T-CHM13 reference genome v2.0](https://github.com/marbl/CHM13). 

[Data is available here](https://drive.google.com/drive/folders/1XHpFu_SLAtgF3kZuzRC1WeH5LXtIv4NW?usp=sharing)

Specifically, this directory contains three types of data:

* `Masked`: Recombination maps created after application of a [short read accessibility mask](https://github.com/marbl/CHM13), removing regions with low-confidence read alignment.
* `No mask`: Recombination maps created without use of an accessibility mask.
* `No mask, scaled to deCODE`:  Recombination maps created without use of an accessibility mask and subsequently scaled to deCODE map lengths.

Each set of recombination maps is available as a set of population-specific maps and as an averaged map for the entire 1KGP dataset. 

## Directory Structure

Each directory contains more a specific README 

### Inputs

Contains all non-vcf files necessary for running scripts.

### Scripts

All scripts used for generating recombination maps. Contains scripts for the following:

* `preprcessing`: Necessary scripts to run on 1KGP vcfs prior to creating recombination maps. Separates vcfs per population and applies quality filtering to chrX vcfs. 
* `autosomes`: Directory contains scripts to create per-population and averaged recombination maps for all autosomes. 
* `chrX`: Contains scripts to apply accessibility mask to chrX and separate per population. Contains directories with recombination map scripts for **pseudoautosomal** and **non-pseudoautosomal** regions 


* `variance_sorted_1mb.csv` - table of variance in recombination rates across populations. Sorted in descending order. Variance was computed in nonoverlapping 1 Mb windows.
