library(ggplot2)
library(dplyr)
library(data.table)

args = commandArgs(trailingOnly=TRUE)

wSize <- as.numeric(args[1])

# Get names of populations 

meta <- read.table("make_table_pop_sizes.txt", 
                   header = FALSE)

colnames(meta) <- c("pop", "notImportant", "notImportant2")

pops <- meta$pop


# Import data 
target_dir <- paste0("pyrho_decode_correlations/w",
                     wSize, "/")


weighted_correlations <- c()
for (pop in pops){
  inName <- paste0(target_dir, 
                   pop,
                   "_chr1_w",
                   wSize,
                   "_correlation.csv")
  df <- read.csv(inName)
  
  for (chromosome in seq(2, 22)){
    inName <- paste0(target_dir, 
                     pop,
                     "_chr",
                     chromosome,
                     "_w",
                     wSize,
                     "_correlation.csv")
    
    to_add <- read.csv(inName)
    
    df <- rbind(df, to_add)
  }
  
  weighted_correlation <- weighted.mean(df$correlation, w = df$length)
  weighted_correlations <- c(weighted_correlations,
                            weighted_correlation)
}

print(weighted_correlations)
print(mean(weighted_correlations))

df <- data.frame(
  pop = pops,
  weighted_correlations = weighted_correlations
)

df <- df %>%
  mutate(ACG = ifelse(pop %in% c("ACB", "ASW", "ESN", "GWD", "LWK", "MSL", "YRI"), "AFR",
                      ifelse(pop %in% c("CDX", "CHB", "CHS", "JPT", "KHV"), "EAS",
                             ifelse(pop %in% c("CEU", "FIN", "GBR", "IBS", "TSI"), "EUR",
                                    ifelse(pop %in% c("BEB", "GIH", "ITU", "PJL", "STU"), "SAS", 
                                           ifelse(pop %in% c("CLM", "MXL", "PEL", "PUR"), "AMR", "NONE"))))))


df$pop <- factor(df$pop, levels = c("ACB", "ASW", "ESN", "GWD", "LWK", "MSL", "YRI",
                                                  "CDX", "CHB", "CHS", "JPT", "KHV",
                                                  "CEU", "FIN", "GBR", "IBS", "TSI",
                                                  "BEB", "GIH", "ITU", "PJL", "STU",
                                                  "CLM", "MXL", "PEL", "PUR"))

a <- ggplot(df, aes(x = pop, y = weighted_correlations, color = ACG)) + 
  geom_point() +
  theme_bw()

ggsave("weighted_corr.png", dpi = 300)