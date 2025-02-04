library(tidyverse)
library(ggplot2)

overlaps <- read.table("hotspot_overlap_deCODE_unique_to_pyrho.txt", 
                       skip = 1,
                       col.names = c('Pop', 'Unique.pyrho', 'Total.pyrho')) %>%
  mutate(n_shared = Total.pyrho - Unique.pyrho) %>%
  mutate(pct_shared = n_shared/Total.pyrho)

overlaps$Pop <- factor(overlaps$Pop, levels = c("YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB",
                                                "CHB", "JPT", "CHS", "CDX", "KHV", 
                                                "CEU", "TSI", "FIN", "GBR", "IBS",
                                                "MXL", "PUR", "CLM", "PEL",
                                                "PJL", "BEB", "GIH", "STU", "ITU"))

overlaps <- overlaps %>% 
  mutate(Superpop = ifelse(Pop %in% c("CHB", "JPT", "CHS", "CDX", "KHV"), "EAS",
                           ifelse(Pop %in% c("CEU", "TSI", "FIN", "GBR", "IBS"), "EUR",
                                  ifelse(Pop %in% c("YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB"), "AFR", 
                                         ifelse(Pop %in% c("MXL", "PUR", "CLM", "PEL"), "AMR", 
                                                ifelse(Pop == "Average", "Average", "SAS"))))))

ggplot(overlaps, aes(x=Pop, y = pct_shared, color = Superpop)) + 
  theme_classic() + 
  labs(color="Continental Group") +
  xlab("Population") +
  ylab("Percent hotspots found in deCODE") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        panel.grid.major.x = element_line(colour = "grey", size = 0.2))+ 
  geom_point()
 
ggsave('~/percent_overlap_deCODE.png',
       width = 6,
       height = 4)
