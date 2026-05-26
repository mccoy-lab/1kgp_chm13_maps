library(dplyr)
library(ggplot2)

pops <- unique(sapply(strsplit(list.files("../pyrho_1kgp_chm13_unphased_no_mask/opt_params"), "_"), function(x) x[1]))


for (pop in pops){
  print(pop)
  all_maps <- data.frame(matrix(ncol=4,nrow=0, 
                                dimnames=list(NULL, c("Chromosome", "Start", "End", "Rec.Rate.Scaled"))))
  
  for (chromosome in seq(1,22)){
    in_map <- read.table(paste0("../pyrho_1kgp_chm13_unphased_no_mask/opt_params_scaled_deCODE/",
                                pop,
                                "_chr",
                                chromosome,
                                "_scaled_deCODE.rmap"), 
                         col.names = c("Start", "End", "Rec.Rate.Scaled")) %>%
      mutate(Chromosome = chromosome)
    
    all_maps <- rbind(all_maps, in_map[c("Chromosome", "Start", "End", "Rec.Rate.Scaled")])
  }
  
  all_maps <- all_maps %>%
    mutate(interval = End-Start) %>%
    mutate(rec.rate.times.interval = Rec.Rate.Scaled * interval)
  
  #avg_rec <- sum(all_maps$rec.rate.times.interval) / sum(all_maps$interval)
  avg_rec <- sum(all_maps$rec.rate.times.interval) / 3054815472
  
  print(avg_rec)
  
  for (thresh in c(5, 10, 50, 100)){
    print(thresh)
    
    hot_map <- all_maps %>%
      mutate(hotspot = ifelse(Rec.Rate.Scaled > (thresh * avg_rec), TRUE, FALSE))
    
    hotspots <- hot_map[hot_map$hotspot == TRUE, c("Chromosome", 
                                                   "Start", 
                                                   "End",
                                                   "Rec.Rate.Scaled")]
    
    out_name <- paste0("hotspots/chm13/", thresh, "x/", pop, "_", thresh, "x_hotspots.csv")
    write.csv(hotspots, out_name, quote = FALSE, row.names = FALSE)
  }
}