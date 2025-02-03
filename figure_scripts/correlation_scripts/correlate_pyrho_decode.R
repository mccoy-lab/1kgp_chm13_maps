library(ggplot2)
library(dplyr)
library(data.table)

args = commandArgs(trailingOnly=TRUE)

pop <- args[1]
chromosome <- args[2]
wSize <- as.numeric(args[3])

# Split into windows function
# Function to split into windows
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

split_into_windows_DECODE <- function(recMap, window_size){
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
        mutate(interval_range = End - Start) %>% # Calculate range of feature that overlaps window 
        mutate(cM = recomb_rate_cMmB * (interval_range)/1000000)
      
      sumCM.Scaled <- sum(recMap_in_interval$cM)
      
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

# Import pyrho data

in_name <- paste0("../recombination_maps_for_publication/no_mask/population_specific/",
                  pop, 
                  "_chr",
                  chromosome,
                  "_no_mask.txt")

pyrhoMap <- read.table(in_name, 
                       sep = ",",
                       header = TRUE) %>%
  mutate(interval = End-Start)# %>%
# mutate(rec.rate.cMmB = Rec.Rate * 100 * 1000000) %>%
# mutate(cM = rec.rate.cMmB * interval/1000000) %>%
# mutate(cumSumcM_compare = cumsum(cM))


# Import decode map

in_name_decode <- paste0("../deCODE/decodeChm13_masked/decodeChr",
                         chromosome,
                         "CHM13_masked.bed")


decode_map <- read.table(in_name_decode)

colnames(decode_map) <- c("Chrom", "Start", "End", "recomb_rate_cMmB")

decode_map <- decode_map %>%
  mutate(interval = End-Start) %>%
  mutate(cM = recomb_rate_cMmB * interval/1000000) %>%
  mutate(cumSumcM = cumsum(cM))

# deCODE chromosome length
chr_len_deCODE <- decode_map$cumSumcM[length(decode_map$cumSumcM)]

# Analysis 
# Scale pyrho map to decode length
scalingFactor <- chr_len_deCODE / pyrhoMap$cumulative.cM[nrow(pyrhoMap)]
# Split pyrho map 
pyrhoMap <- pyrhoMap %>%
  mutate(Rec.Rate = Rec.Rate * scalingFactor)

# Split pyrho map
pyrhoSplit <- split_into_windows(pyrhoMap, wSize) %>%
  mutate(cM.Scaled = as.numeric(cM.Scaled))


# Split decode
decodeSplit <- split_into_windows_DECODE(decode_map, wSize) %>%
  mutate(cM.Scaled = as.numeric(cM.Scaled))

# Merge decode and pyrho
merged <- merge(pyrhoSplit, decodeSplit, by = "Start", all = FALSE)
merged <- na.omit(merged)
#merged[is.na(merged)] <- 0

# Get correlation
length <- pyrhoMap$End[nrow(pyrhoMap)]
correlation <- cor(merged$cM.Scaled.x, merged$cM.Scaled.y, method = "spearman")

# Plot
fig <- ggplot(merged, aes(x = cM.Scaled.x, y = cM.Scaled.y)) +
  geom_point() +
  theme_classic()

outName <- paste0("/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_revisions/pyrho_decode_plots/",
                  "w", wSize, "/",
                  pop, "_chr",
                  chromosome, "_w",
                  wSize, ".png")
ggsave(outName, fig, dpi = 300)
  
# Save Correlation
outName <- paste0("/home/abortvi2/scr16_rmccoy22/abortvi2/pyrho_revisions/pyrho_decode_correlations/",
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


# df <- data.frame(
#   chr = seq(1, 22),
#   lengths = lengths,
#   correlation = correlations
# )
# 
# fig <- ggplot(df, aes(x = chr, y = correlations, color = lengths)) + 
#   geom_point() + 
#   xlab("Chromsome Length (bp)") + 
#   ylab("Spearman Corrleation") + 
#   theme_classic()
# 
# 
# ggsave("~/correlate_pyrho_decode.png", fig, dpi = 300)
