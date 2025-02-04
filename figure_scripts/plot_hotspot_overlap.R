library(tidyverse)
library(ggplot2)

overlaps <- read.table("hotspot_overlap.txt", 
           skip = 1,
           col.names = c('Pop1', 'Pop2', 'Unique.Pop1', 'Total.Pop1'))
   
pops <- unique(overlaps$Pop1) 

pop1_list <- c()
pop2_list <- c()
for(i in seq(length(pops) - 1)){
  for (j in seq(i + 1, length(pops))){
    pop1_list <- c(pop1_list, pops[i])
    pop2_list <- c(pop2_list, pops[j])
  }
}

df <- data.frame(Pop1 = pop1_list, Pop2 = pop2_list) %>%
  mutate(Unique.Pop1 = NA) %>%
  mutate(Total.Pop1 = NA) %>%
  mutate(Unique.Pop2 = NA) %>%
  mutate(Total.Pop1 = NA)

for (i in seq(nrow(df))){
  p1 <- df$Pop1[i]
  p2 <- df$Pop2[i]
  
  df[i, "Unique.Pop1"] = overlaps[overlaps$Pop1 == p1 & overlaps$Pop2 == p2, "Unique.Pop1"]
  df[i, "Unique.Pop2"] = overlaps[overlaps$Pop1 == p2 & overlaps$Pop2 == p1, "Unique.Pop1"]
  df[i, "Total.Pop1"] = overlaps[overlaps$Pop1 == p1 & overlaps$Pop2 == p2, "Total.Pop1"]
  df[i, "Total.Pop2"] = overlaps[overlaps$Pop1 == p2 & overlaps$Pop2 == p1, "Total.Pop1"]
}

df <- df %>% 
  mutate(Shared.Pop1 = Total.Pop1 - Unique.Pop1) %>%
  mutate(Shared.Pop2 = Total.Pop2 - Unique.Pop2) %>%
  mutate(Total.Both.Pops = Unique.Pop1 + Unique.Pop2 + Shared.Pop1 + Shared.Pop2) %>%
  mutate(Pct.Shared = (Shared.Pop1 + Shared.Pop2) / Total.Both.Pops)

df$Pop1 <- factor(df$Pop1, levels = c("CHB", "JPT", "CHS", "CDX", "KHV", 
                                                "CEU", "TSI", "FIN", "GBR", "IBS",
                                                "YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB",
                                                "MXL", "PUR", "CLM", "PEL",
                                                "PJL", "BEB", "GIH", "STU", "ITU"))

df$Pop2 <- factor(df$Pop2, levels = c("CHB", "JPT", "CHS", "CDX", "KHV", 
                                      "CEU", "TSI", "FIN", "GBR", "IBS",
                                      "YRI", "LWK", "GWD", "MSL", "ESN", "ASW", "ACB",
                                      "MXL", "PUR", "CLM", "PEL",
                                      "PJL", "BEB", "GIH", "STU", "ITU"))

df2 <- df 
df2["Pop1"] = df["Pop2"]
df2["Pop2"] = df["Pop1"]

plt_me <- rbind(df,df2)

for (i in pops){
  plt_me <- rbind(plt_me, c(i, i, NA, NA, NA, NA, NA, NA, NA, 1))
}

plt_me <- plt_me %>%
  mutate(Pct.Shared = as.numeric(Pct.Shared) * 100)

ggplot(plt_me, aes(x = Pop1, y = Pop2, fill = Pct.Shared)) +
  geom_tile() + 
  scale_fill_viridis_c() + 
  theme_classic() + 
  labs(x = NULL, y = NULL, fill = "Percent hotspots\nshared") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  coord_fixed()

# ggsave('~/hotspot_heatmap.png',
#        width = 8, 
#        height = 4)
