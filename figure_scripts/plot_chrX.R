library(tidyverse)
library(ggplot2)
library(khroma)
library(RColorBrewer)

pops <- unique(sapply(strsplit(list.files("opt_params"), "_"), function(x) x[1]))

all_maps <- data.frame(matrix(ncol=4,nrow=0, 
                              dimnames=list(NULL, c("Start", "End", "cumSumcM", "Pop"))))

print("Reading in population data")
for (pop in pops){
  in_name <- paste0("chrX_deCODE_scaled/", pop, "_chrX_scaled_deCODE.rmap")
  in_chrX <- read.table(in_name,
                        col.names = c("Start", "End", "Rec.Rate")) %>%
    mutate(interval = End-Start) %>%
    mutate(rec.rate.cMmB = Rec.Rate * 100 * 1000000) %>%
    mutate(cM = rec.rate.cMmB * interval/1000000)%>%
    mutate(cumSumcM = cumsum(cM)) %>%
    mutate(Pop = pop)
  
  all_maps <- rbind(all_maps, in_chrX[c("Start", "End", "cumSumcM", "Pop")])
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


# Reading in Averaged Map
avg_map <- read.table("averagedByBase_scaled_to_deCODE/chrX.txt",
                                   col.names = c("Start", "End", "Rec.Rate")) %>%
  mutate(interval = End-Start) %>%
  mutate(rec.rate.cMmB = Rec.Rate * 100 * 1000000) %>%
  mutate(cM = rec.rate.cMmB * interval/1000000)%>%
  mutate(cumSumcM = cumsum(cM)) %>%
  mutate(Pop = "Average") %>%
  mutate(Superpop = "Average") %>% 
  mutate(Start_MB = Start/1000000)
  
print("Plotting")

# a <- ggplot(all_maps, aes(x = Start, y = cumSumcM, group = Pop, color = Superpop)) +
#   geom_line(linewidth = 0.5, alpha = 0.5) +
#   geom_line(data = avg_map, linewidth = 1.2, color = 'black') + 
#   theme_classic() +
#   labs(color="Superpopulation") +
#   xlab("Genomic Position (bp)") +
#   ylab("Cumulative cM") + 
#   geom_vline(xintercept = c(2394410, 153925834),
#             linetype="dashed")
#   

all_maps <- all_maps %>% 
  mutate(Start_MB = Start/1000000)

ggplot(all_maps, aes(x = Start_MB, y = cumSumcM, group = Pop, color = Superpop)) +
  geom_line(linewidth = 0.5, alpha = 0.5) +
  geom_line(data = avg_map, linewidth = 1.2, color = 'black') + 
  theme_classic() +
  labs(color="Continental Group") +
  xlab("Genomic Position (Mb)") +
  ylab("Cumulative cM") + 
  geom_vline(xintercept = c(2394410/1000000, 153925834/1000000),
             linetype="dashed")

ggsave("~/x_map.png",
       width = 5,
       height = 4)
