# Pratto Comparisons

Contains the code necessary to compare 1KGP CHM13 recombination maps to Pratto et al 2014 a-DMC1 ChIP data. 

Pratto et al data was reanalyzed using the SSDSpipeline: https://github.com/kevbrick/SSDSpipeline

The results of that were lifted over to the CHM13 v2.0 reference. `reformat_pratto_for liftover.py` and `reformat_pratto_for_liftover_A_C.py` prepare data from Pratto et al for liftover. 

The directories `lifotver_input`, `lifotver_input_A_C`, `lifted_over`, and `lifted_over_A_C` contain the inputs and outputs of that liftover. 

`get_overlaps.sh	` and `get_overlaps_A_C.sh` intersect lifted over Pratto et al data with T2T Chm13 recombination maps.

`pratto_overlaps_fig` contains plotting code for comparison of recombination maps to Pratto et al 2014. 

The directory `non_syntenic_pratto_comparison` has code to compare Pratto et al 2014 data with non-syntenic regions of recombination maps. 

For comparisons of hotspots across populations: `get_chm13_hotspots.R` and `get_hg38_hotspots.R` calculate the locations of hotspots. `compact_chm13_hotspots.py` and `compact_hg38_hotspots.py` reformat hotspots so that they can be intersected with each other `bedtools_intersect_hotspots.sh` intersects hotspots across populations. Output is plotted using: `plot_pratto_overlaps.R`. The directory `hotspot_overlap_fig` contains plotting code for the figure displaying overlap between hotspots across populations.