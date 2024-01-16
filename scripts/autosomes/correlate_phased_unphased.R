library(tidyverse)
library(ggplot2)

# Get parameters
args = commandArgs(trailingOnly=TRUE)

pop <- args[1]
chr <- args[2] 

window_length = 10000

# Get the list of optimized parameters for this population 
optimized_params <- read.table(paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_array/optimize_paramaters/', 
                                      pop, '_optimize_params.txt'),
                               header = FALSE,
                               col.names = c('Block_Penalty', 'Window_Size', 'Optimized_Parameter'))

split_into_windows <- function(fname, chr_name, window_size) {
  
  chr <- read.table(fname,
                    header=FALSE,
                    col.names=c("chr", "start", "stop", "rec_rate"))
  
  chr_length <- chr$stop[nrow(chr)]
  n_windows <- floor(chr_length/window_size) + 1
  
  out_map <- data.frame(matrix(ncol = 4, nrow = 0))
  colnames(out_map) <- c("chr", "start", "stop", "distance")
  
  for (i in 0:n_windows){
    #for (i in 0:50){
    interval_start <- i * window_size + 1
    interval_stop <- (i+1) * window_size
    
    chr_in_interval <- chr[chr$start < interval_stop & chr$stop > interval_start, ] %>%
      mutate(start = ifelse(start < interval_start, interval_start, start)) %>% # If any part of the feature is outside the window, exclude it. 
      mutate(stop = ifelse(stop > interval_stop, interval_stop, stop))
    
    if (nrow(chr_in_interval) > 0){
      chr_in_interval <- chr_in_interval %>% 
        mutate(recomb_rate_cMmB = rec_rate * 100 * 1000000) %>%
        mutate(cM = recomb_rate_cMmB * (stop-start)/1000000) 
      
      sumCM <- sum(chr_in_interval$cM)
      
      out_map[nrow(out_map) + 1, ] <- c(chr_name, interval_start, interval_stop, sumCM)
    }
    
    if (i %% 1000 == 0){
      print(i)
    }
  }
  
  out_map <- out_map %>%
    mutate(start = as.numeric(start)) %>%
    mutate(stop = as.numeric(stop)) %>%
    mutate(distance = as.numeric(distance))
}

# Initialize correlation table
correlation_table <- data.frame(matrix(nrow=0, ncol=2, dimnames=list(NULL, c("comparison", "correlation"))))

# Read in hg38 data and process 
out_map_hg38 <- split_into_windows(paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_array/hg38_maps_lifted_to_chm13v2_masked/', pop, '_recombination_map_chm13v2_chr_', chr, '_masked.bed'), 
                                   paste0('chr', chr), window_length)
out_map_hg38_to_paste <- cbind(out_map_hg38, reference="hg38")

# Getting optimized parameters
window <- optimized_params$Window_Size[grep("L2", optimized_params$Optimized_Parameter)]
penalty <- optimized_params$Block_Penalty[grep("L2", optimized_params$Optimized_Parameter)]

# Read in phased chm13 data and process
out_map_phased <- split_into_windows(paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_array/opt_params_masked_masked/', pop, '_chr', chr, 
                                     '_w', window, '_b', penalty, '_masked_masked.rmap'), 
                              paste0('chr', chr), window_length)
out_map_phased_to_paste <- cbind(out_map_phased, reference="chm13_phased")

# Read in unphased chm13 data and process
out_map_unphased <- split_into_windows(paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_unphased/opt_params_masked_masked/', pop, '_chr', chr, 
                                     '_w', window, '_b', penalty, '_masked_masked.rmap'), 
                              paste0('chr', chr), window_length)
out_map_unphased_to_paste <- cbind(out_map_unphased, reference="chm13_unphased")

## Correlate phased chm13 and hg38
corelate_me <- merge(out_map_phased_to_paste, out_map_hg38_to_paste, by='start') 
correlation <- cor(corelate_me$distance.x, corelate_me$distance.y, method = "spearman")
correlation_table[nrow(correlation_table) + 1, ] <- c("chm13_phased,hg38", correlation)

## Correlate unphased chm13 and hg38
corelate_me <- merge(out_map_unphased_to_paste, out_map_hg38_to_paste, by='start') 
correlation <- cor(corelate_me$distance.x, corelate_me$distance.y, method = "spearman")
correlation_table[nrow(correlation_table) + 1, ] <- c("chm13_unphased,hg38", correlation)

## Correlate unphased chm13 and phased chm13
corelate_me <- merge(out_map_unphased_to_paste, out_map_phased_to_paste, by='start') 
correlation <- cor(corelate_me$distance.x, corelate_me$distance.y, method = "spearman")
correlation_table[nrow(correlation_table) + 1, ] <- c("chm13_unphased,chm13_phased", correlation)

out_name <- paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_unphased/correlations_spearman/', pop, '_chr', chr, '_correlations_Spearman.csv')

write.table(correlation_table,
            out_name,
            sep="\t",
            quote=FALSE,
            row.names = FALSE)
