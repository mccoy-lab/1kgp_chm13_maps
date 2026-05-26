library(ggplot2)
library(dplyr)
library(reshape2)
library(RColorBrewer)

df5 <- read.table("all_overlaps_5x.txt",
                  header = TRUE) %>% 
  mutate(threshold = "5x")


df <- read.table("all_overlaps_10x.txt",
                 header = TRUE) %>% 
  mutate(threshold = "10x")

df2 <- read.table("all_overlaps_50x.txt",
                  header = TRUE) %>% 
  mutate(threshold = "50x")

df3 <- read.table("all_overlaps_100x.txt",
                  header = TRUE) %>% 
  mutate(threshold = "100x")

df_plt <- rbind(df, df2)
df_plt <- rbind(df_plt, df5)
df_plt <- rbind(df_plt, df3) %>%
  mutate(frac_chm13 = n_intersect_chm13 / total_chm13) %>%
  mutate(frac_hg38 = n_intersect_hg38 / total_hg38)

df_tall <- melt(df_plt[, c("pop", "frac_chm13", "frac_hg38", "threshold")], id.vars = c("pop", "threshold"), variable.name = "map") %>%
  mutate(Superpop = ifelse(pop %in% c("CHB", "JPT", "CHS", "CDX", "KHV"), "EAS",
                           ifelse(pop %in% c("CEU", "TSI", "FIN", "GBR", "IBS"), "EUR",
                                  ifelse(pop %in% c("YRI", "LWK", "GWD", "MAG", "MSL", "ESN", "ASW", "ACB"), "AFR", 
                                         ifelse(pop %in% c("MXL", "PUR", "CLM", "PEL"), "AMR", 
                                                ifelse(pop == "Average", "Average", "SAS"))))))

df_tall$Superpop <- factor(df_tall$Superpop, 
                           levels = c("AFR", "EAS", "SAS", "EUR", "AMR"))

df_tall$pop <- factor(df$pop, 
                      levels = c("YRI", "LWK", "MAG", "MSL", "ESN", "ASW", "ACB", "GWD",
                                 "CHB", "JPT", "CHS", "CDX", "KHV",
                                 "BEB", "GIH", "ITU", "PJL", "STU",
                                 "CEU", "TSI", "FIN", "GBR", "IBS",
                                 "MXL", "PUR", "CLM", "PEL"))

df_tall$map <- as.character(df_tall$map)
df_tall[df_tall["map"] == "frac_chm13", "map"] <- "CHM13"
df_tall[df_tall["map"] == "frac_hg38", "map"] <- "GRCh38"

df_tall$threshold = factor(df_tall$threshold,
                           levels = c("5x", "10x", "50x", "100x"))

ggplot(df_tall[df_tall$threshold != "100x", ], aes(x = pop, 
                                                   y = value, 
                                                   color = Superpop,
                                                   shape= map,
                                                   group = map)) +
  geom_line(aes(group = pop), 
            color = "grey") + 
  geom_point(size = 3) +
  theme_classic() +
  scale_color_brewer(palette = "Set2") +
  facet_wrap(~threshold) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + 
  labs(x = "Population", 
       y = "% LD hotspots overlapping DMC1 CHIP-seq peaks", 
       color = "Continental\nGroup",
       shape =  "Recombination\nMap")

ggsave("pratto_overlap.png",
       dpi = 300)