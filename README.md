# 1KGP T2T-CHM13 Maps

Recombination maps generated using [pyrho](https://github.com/popgenmethods/pyrho) for autosomes and X chromosomes from the Thousand Genomes Project (1KGP), realigned to the [T2T-CHM13 reference genome v2.0](https://github.com/marbl/CHM13). 

[Data is available here](https://drive.google.com/drive/folders/1XHpFu_SLAtgF3kZuzRC1WeH5LXtIv4NW?usp=sharing)

Recombination maps have been generated both with and without the use of a [short read accessibility mask](https://github.com/marbl/CHM13). 

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

