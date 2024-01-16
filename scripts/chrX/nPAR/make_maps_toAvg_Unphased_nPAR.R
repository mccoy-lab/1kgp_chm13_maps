library(tidyverse)

popFiles <- list.files('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_unphased/chrX_nPAR/opt_params_masked_masked')

for (f in popFiles){
  pop <-  strsplit(f, '_')[[1]][1]
  
  # Get the list of optimized parameters for this population
  optimized_params <- read.table(paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_unphased/chrX_nPAR/optimize_paramaters/',
                                        pop, '_optimize_params_nPAR.txt'),
                                 header = FALSE,
                                 col.names = c('Block_Penalty', 'Window_Size', 'Optimized_Parameter'))

  window <- optimized_params$Window_Size[grepl("L2", optimized_params$Optimized_Parameter)]
  penalty <- optimized_params$Block_Penalty[grepl("L2", optimized_params$Optimized_Parameter)]
  
  in_name <- paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_unphased/chrX_nPAR/opt_params_masked_masked/', f)

  map_masked <- read.table(in_name,
                           header=FALSE,
                           col.names=c('chr', 'start', 'stop', 'recomb_rate')) %>%
    mutate(interval = stop-start) %>%
    mutate(recomb_rate_cMmB = recomb_rate * 100 * 1000000) %>%
    mutate(cM = recomb_rate_cMmB * interval/1000000) %>%
    mutate(cumSumcM = cumsum(cM))


  map_masked <- map_masked[map_masked$cM<1,]


  out_name <- paste0('/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_1kgp_chm13_unphased/chrX_nPAR/opt_params_toAvg/', pop, '_chrX_nPAR.tsv')


  write.table(map_masked,
            out_name,
            sep='\t',
            quote=FALSE,
            row.names = FALSE)
}
