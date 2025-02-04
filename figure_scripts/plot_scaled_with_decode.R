library(tidyverse)
library(ggplot2)


for (chromosome in seq(1,22)){
  print(chromosome)
  # Import deCODE data and get cumulative cM
  deCode <- read.csv(paste0("../deCODE/decodeChm13/decodeChr", chromosome, "CHM13.bed"), 
                     sep = "\t", 
                     header = FALSE,
                     col.names = c("Chr", "Start", "End", "recomb_rate_cMmB")) %>%
    mutate(interval = End-Start) %>%
    mutate(cM = recomb_rate_cMmB * interval/1000000) %>%
    mutate(cumSumcM = cumsum(cM))
  # deCODE chromosome length
  chr_len_deCODE <- deCode$cumSumcM[length(deCode$cumSumcM)]
  # Initialize df for all pops
  all_maps <- data.frame(matrix(ncol=3,nrow=0, 
                                dimnames=list(NULL, c("Start", "cumSumcM.Scaled", "Pop"))))
  pops <- unique(sapply(strsplit(list.files("opt_params"), "_"), function(x) x[1]))
  for (pop in pops){
    print(pop)
    fname_prefix <- paste0(pop, "_chr", chromosome, "_")
    in_name <- paste0("opt_params/", list.files("opt_params")[grep(fname_prefix, list.files("opt_params"))])
    
    chrMap <- read.csv(in_name,
             sep = "\t",
             header = FALSE,
             col.names = c("Start", "End", "Rec.Rate")) %>%
      mutate(Pop = pop) %>%
      mutate(Genome = "chm13") %>%
      mutate(interval = End-Start) %>%
      mutate(rec.rate.cMmB = Rec.Rate * 100 * 1000000) %>%
      mutate(cM = rec.rate.cMmB * interval/1000000)
    
    chrMap <- chrMap[chrMap$cM < 1, ] %>%
      mutate(cumSumcM = cumsum(cM))
    
    chr_len_pyrho <- chrMap$cumSumcM[length(chrMap$cumSumcM)]
    scaling_factor <- chr_len_deCODE / chr_len_pyrho
    
    chrMap <- chrMap %>% 
      mutate(rec.rate.cMmB.Scaled = rec.rate.cMmB * scaling_factor) %>%
      mutate(cM.Scaled = rec.rate.cMmB.Scaled * interval/1000000) %>%
      mutate(cumSumcM.Scaled = cumsum(cM.Scaled))
    
    all_maps <- rbind(all_maps, chrMap[, c("Start", "cumSumcM.Scaled", "Pop")])
  }
  all_maps <- all_maps %>% 
        mutate(Superpop = ifelse(Pop %in% c("CHB", "JPT", "CHS", "CDX", "KHV"), "EAS",
           ifelse(Pop %in% c("CEU", "TSI", "FIN", "GBR", "IBS"), "EUR",
                  ifelse(Pop %in% c("YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB"), "AFR", 
                         ifelse(Pop %in% c("MXL", "PUR", "CLM", "PEL"), "AMR", 
                                ifelse(Pop == "Average", "Average", "SAS"))))))
  all_maps$Pop <- factor(all_maps$Pop, levels = c("CHB", "JPT", "CHS", "CDX", "KHV", 
                                                  "CEU", "TSI", "FIN", "GBR", "IBS",
                                                  "YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB",
                                                  "MXL", "PUR", "CLM", "PEL",
                                                  "PJL", "BEB", "GIH", "STU", "ITU"))
  deCode <- deCode %>%
    mutate(dataset = "deCODE") 
  
  plt <- ggplot(all_maps, aes(x = Start, y = cumSumcM.Scaled)) + 
    geom_line(aes(group = Pop, color = Superpop)) + 
    geom_line(data = deCode, aes(x = Start, y = cumSumcM, color = dataset), color = 'black') + 
    xlab("Position") + 
    ylab("Cumulative cM") + 
    ggtitle(paste0("chr", chromosome)) + 
    theme_classic()
  
  outName <- paste0("scaled_whole_chr_with_deCODE/chr", chromosome, "_scaled_with_deCODE.png")
  ggsave(outName, plot = plt, width = 10, height = 8)
}
