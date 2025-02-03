library(ggplot2)
library(dplyr)
library(data.table)

args = commandArgs(trailingOnly=TRUE)

pop <- args[1]
chromosome <- args[2]
wSize <- as.numeric(args[3])

# Import chm13 data

in_name <- paste0("../recombination_maps_for_publication/no_mask/population_specific/",
                  pop, 
                  "_chr",
                  chromosome,
                  "_no_mask.txt")

chm13map <- read.table(in_name, 
                       sep = ",",
                       header = TRUE) %>%
  mutate(interval = End-Start)

# Import hg38 map lifted over
in_name_hg38 <- paste0("../pyrho_1kgp_chm13/hg38_maps_lifted_to_chm13v2/",
                       pop, "/", 
                       pop, 
                       "_recombination_map_chm13v2_chr_",
                       chromosome,
                       ".bed")

hg38map <- read.table(in_name_hg38, 
                       sep = "\t",
                       header = FALSE)

colnames(hg38map) <- c("Chrom", "Start", "End", "Rec.Rate")

# split function
split_into_windows <- function(recMap, window_size){
  chr_length <- recMap$End[nrow(recMap)]
  n_windows <- floor(chr_length/window_size) + 1
  
  out_map <- data.frame(matrix(ncol = 4, nrow = 0))
  colnames(out_map) <- c("Start", "End", "Pop", "cM.Scaled")
  
  for (i in 0:n_windows){
    interval_start <- i * window_size + 1
    interval_stop <- (i+1) * window_size
    
    recMap_in_interval <- recMap[recMap$Start < interval_stop & recMap$End > interval_start, ] %>%
      mutate(Start = ifelse(Start < interval_start, interval_start, Start)) %>% # If any part of the feature is outside the window, exclude it. 
      mutate(End = ifelse(End > interval_stop, interval_stop, End))
    
    if (nrow(recMap_in_interval) > 0){
      recMap_in_interval <- recMap_in_interval %>%
        mutate(rec.rate.Scaled.cMmB = Rec.Rate  * 100 * 1000000) %>%
        mutate(interval_range = End - Start) %>% # Calculate range of feature that overlaps window 
        mutate(cM.Scaled = rec.rate.Scaled.cMmB * (interval_range)/1000000)
      
      sumCM.Scaled <- sum(recMap_in_interval$cM.Scaled)
      
      out_map[nrow(out_map) + 1,] <- c(interval_start, 
                                       interval_stop,
                                       pop,
                                       sumCM.Scaled)
    }
    else {
      out_map[nrow(out_map) + 1,] <- c(interval_start, 
                                       interval_stop,
                                       pop,
                                       NA)
    }
  }
  
  return(out_map)
}

hg38split <- split_into_windows(hg38map, wSize) %>%
  mutate(cM.Scaled = as.numeric(cM.Scaled))
chm13split <- split_into_windows(chm13map, wSize) %>%
  mutate(cM.Scaled = as.numeric(cM.Scaled))

# Merge decode and pyrho
merged <- merge(hg38split, chm13split, by = "Start", all = FALSE)
merged <- na.omit(merged)
#merged[is.na(merged)] <- 0

# Get correlation
length <- chm13split$End[nrow(chm13split)]
correlation <- cor(merged$cM.Scaled.x, merged$cM.Scaled.y, method = "spearman")

fig <- ggplot(merged, aes(x = cM.Scaled.x, y = cM.Scaled.y)) + 
  geom_point() +
  xlab("cM in Window (hg38)") +
  ylab("cM in Window (chm13)") +
  theme_classic()

outName <- paste0("/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_revisions/chm13_hg38_plots/",
                  "w", wSize, "/",
                  pop, "_chr",
                  chromosome, "_w",
                  wSize, ".png")
ggsave(outName, fig, dpi = 300)




outName <- paste0("/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_revisions/chm13_hg38_correlations/",
                  "w", wSize, "/",
                  pop, "_chr",
                  chromosome, "_w",
                  wSize, "_correlation.csv")


df <- data.frame(
  length = length,
  correlation = correlation
)

write.csv(df, outName, 
          quote = FALSE,
          row.names = FALSE)




