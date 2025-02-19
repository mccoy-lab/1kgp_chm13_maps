library(tidyverse)
library(ggplot2)
library(ggridges)

args = commandArgs(trailingOnly=TRUE)
chromosome = "X"
window_size <- as.numeric(args[1])

split_scaled_map <- function(pyrho_map, window_size){
  chr_length <- pyrho_map$Start[nrow(pyrho_map)]
  n_windows <- floor(chr_length/window_size) + 1
  
  
  
  out_map <- data.frame(matrix(ncol = 5, nrow = 0))
  colnames(out_map) <- c("Chr", "Pop", "Start", "End", "cM_scaled_in_window")
  
  for (i in 0:n_windows){
    interval_start <- i * window_size + 1
    interval_stop <- (i+1) * window_size
    
    pyrho_map_in_interval <- pyrho_map[pyrho_map$Start < interval_stop & pyrho_map$End > interval_start, ] %>%
      mutate(Start = ifelse(Start < interval_start, interval_start, Start)) %>% # If any part of the feature is outside the window, exclude it.
      mutate(End = ifelse(End > interval_stop, interval_stop, End))
    
    if (nrow(pyrho_map_in_interval) > 0){
      cM_scaled_in_window <- sum(pyrho_map_in_interval$cM)
      
      out_map[nrow(out_map) + 1, ] <- c(paste0("chr", chromosome), pop, interval_start, interval_stop, cM_scaled_in_window)
    }
  }
  
  out_map <- out_map %>%
    mutate(Start = as.numeric(Start)) %>%
    mutate(End = as.numeric(End)) %>%
    mutate(cM_scaled_in_window = as.numeric(cM_scaled_in_window))
}

# Initialize df for all pops
all_maps <- data.frame(matrix(ncol=5,nrow=0, 
                              dimnames=list(NULL, c("Chr", "Pop", "Start", "End", "cM_scaled_in_window"))))

pops <- unique(sapply(strsplit(list.files("../../pyrho_1kgp_chm13_unphased_no_mask/opt_params"), "_"), function(x) x[1]))

for (pop in pops){
  print(pop)
  fname_prefix <- paste0(pop, "_chrX_scaled_deCODE.rmap")
  
  in_name <- paste0("../../pyrho_1kgp_chm13_unphased_no_mask/chrX_deCODE_scaled/", fname_prefix)
  
  chrMap <- read.csv(in_name,
                     sep = "\t",
                     header = FALSE,
                     col.names = c("Start", "End", "Rec.Rate")) %>%
    mutate(Pop = pop) %>%
    mutate(interval = End-Start) %>%
    mutate(rec.rate.cMmB = Rec.Rate * 100 * 1000000) %>%
    mutate(cM = rec.rate.cMmB * interval/1000000)
  
  chrMap <- chrMap[chrMap$cM < 1, ] %>%
    mutate(cumSumcM = cumsum(cM))
  
  all_maps <- rbind(all_maps, split_scaled_map(chrMap, window_size))
}

# Initialize df for all pops
cov_Var <- data.frame(matrix(ncol=6,nrow=0,
                              dimnames=list(NULL, c("Chr", "Start", "mean", "variance", "sd", "cV"))))

max_len <- max(all_maps$End)
n_windows <- max_len/window_size

for (i in seq(1, n_windows)){
  subset_all_maps <- all_maps[all_maps$End == (i * window_size), "cM_scaled_in_window"]
  meanVal <- mean(subset_all_maps)
  sdVal <- sd(subset_all_maps)
  CoV <- sdVal/meanVal
  variance <- var(subset_all_maps)
  cov_Var[nrow(cov_Var) + 1,] <- c(paste0("chr", chromosome),
                                   ((i-1) * window_size) + 1,
                                   meanVal,
                                   variance,
                                   sdVal,
                                   CoV)
}


out_df <- cov_Var[, c("Chr", "Start", "mean", "variance" )] %>%
  arrange(desc(variance))

write_csv(out_df,
          paste0("variance_tables/chrX.csv"))







# 
# cov_Var <- cov_Var %>%
#   mutate(Start = as.numeric(Start)) %>%
#   mutate(cV = as.numeric(cV)) %>%
#   mutate(sd = as.numeric(sd)) %>%
#   mutate(mean = as.numeric(mean)) %>%
#   mutate(variance = as.numeric(variance)) %>%
#   mutate(x_coord_plot = 0 )
# 
# 
# cov_Var_tall <- pivot_longer(cov_Var, cols = c('mean', 'sd', 'cV', 'variance'), names_to = 'metric') %>%
#   mutate(value = ifelse(metric == 'mean', -1 * value, value)) %>% 
#   mutate(y_max = ifelse(metric == 'mean', 0, max(cov_Var$sd, na.rm = TRUE))) %>%
#   mutate(y_min = ifelse(metric == 'sd', 0, -1 * max(cov_Var$mean, na.rm = TRUE))) %>%
#   mutate(y_min = ifelse(metric == 'variance', 0, -1 * max(cov_Var$variance, na.rm = TRUE))) 
# 
# cov_Var_tall$metric <- factor(cov_Var_tall$metric, levels = c('sd', 'variance', 'mean', 'cV'))
# 
# # ggplot(cov_Var_tall[cov_Var_tall$metric == 'variance' | cov_Var_tall$metric =='mean', ], aes(x = Start, y = value)) +
# #   geom_point() +
# #   geom_hline(yintercept = 0) + 
# #   geom_segment(aes(xend = Start, y = 0, yend = value), linewidth = 0.3) +
# #   facet_grid(metric~., scales = "free_y", switch = "y") + 
# #   scale_y_discrete(drop = TRUE, expand = c(0, 0)) +
# #   scale_y_continuous(expand = c(0, 0)) + 
# #   theme(strip.placement = "outside",
# #         panel.spacing.y = unit(0, "in"),
# #         strip.background.y = element_rect(fill = "white", color = "white"),
# #         panel.background = element_blank(),
# #         panel.grid.major = element_blank(), 
# #         panel.grid.minor = element_blank(),
# #         axis.title.y=element_blank()) 
# # 
# # out_name <- paste0("var_plots/var_and_mean/chr", chromosome, 
# #                    "_w", window_size, "_var_and_mean.png")
# # ggsave(out_name)
# 
# all_maps_with_var <- merge(all_maps, cov_Var[, c("Start", "variance")], by = "Start") %>%
#   mutate(n_pops = ifelse(Superpop == 'AFR', 7, 
#                          ifelse(Superpop == 'AMR', 4, 5)))
# 
# head(all_maps_with_var)
# 
# # ggplot(all_maps_with_var, aes(x = Start, y = Pop, height = cM_scaled_in_window)) + 
# #   facet_grid(Superpop~., scales = "free", space = "free_y", switch = "y") + 
# #   geom_rect(aes(xmin = Start - window_size/2,
# #                 xmax = Start + window_size/2,
# #                 ymin = -Inf,
# #                 ymax = Inf,
# #                 fill = variance,
# #                 alpha = 0.6/n_pops)) +
# #   geom_ridgeline(fill=NA, color = 'black') +
# #   scale_fill_viridis_c() + 
# #   scale_alpha_continuous(range=c(0.01,1), 
# #                          limits=c(0.01,1),
# #                          guide = "none") +
# #   theme(panel.background = element_rect(fill = 'white', color = 'white'),
# #         panel.grid.major = element_blank(),
# #         panel.grid.minor = element_blank(), 
# #         text = element_text(size=10),
# #         strip.placement = "outside",
# #         panel.spacing.y = unit(0, "in"),
# #         strip.background.y = element_rect(fill = "white", color = "white")) 
# # 
# # out_name <- paste0("var_plots/ridges_and_var/chr", chromosome, 
# #                    "_w", window_size, "_ridges.png")
# # ggsave(out_name)
# 
# 

# 
