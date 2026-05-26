library(ggplot2)
library(dplyr)
library(textshape)
library(tidyr)
library(RColorBrewer)


for (thresh in c(5, 10, 50))
{
  in_name <- paste0("overlaps_", thresh, "x.txt")
  df <- read.table(in_name,
                   header = TRUE,
                   sep = "\t")

  df$proportion <- df$n.overlap / df$n.total
  
  df$pop1 <- factor(df$pop1, 
                    levels = c("YRI", "LWK", "MSL", "ESN", "ASW", "ACB", "GWD",
                               "CHB", "JPT", "CHS", "CDX", "KHV",
                               "BEB", "GIH", "ITU", "PJL", "STU",
                               "CEU", "TSI", "FIN", "GBR", "IBS",
                               "MXL", "PUR", "CLM", "PEL"))
  
  df$pop2 <- factor(df$pop2, 
                    levels = c("YRI", "LWK", "MSL", "ESN", "ASW", "ACB", "GWD",
                               "CHB", "JPT", "CHS", "CDX", "KHV",
                               "BEB", "GIH", "ITU", "PJL", "STU",
                               "CEU", "TSI", "FIN", "GBR", "IBS",
                               "MXL", "PUR", "CLM", "PEL"))
  
  mat <- df[, c("pop1", "pop2", "proportion")] %>%
    pivot_wider(names_from = pop2, values_from = proportion) %>%
    column_to_rownames("pop1") %>% 
    as.matrix()
  
  row_order <- hclust(dist(mat))$order
  col_order <- hclust(dist(t(mat)))$order
  
  df$pop1 <- factor(df$pop1, levels = rownames(mat)[row_order])
  df$pop2 <- factor(df$pop2, levels = colnames(mat)[col_order])
  
  row_anno <- tibble(row = c("YRI", "LWK", "MSL", "ESN", "ASW", "ACB", "GWD",
                             "CHB", "JPT", "CHS", "CDX", "KHV",
                             "BEB", "GIH", "ITU", "PJL", "STU",
                             "CEU", "TSI", "FIN", "GBR", "IBS",
                             "MXL", "PUR", "CLM", "PEL"),
                     group = c(rep("AFR", times = 7),
                               rep("EAS", times = 5),
                               rep("SAS", times = 5),
                               rep("EUR", times = 5),
                               rep("AMR", times = 4)))
  
  row_anno <- row_anno[row_order, ]
  
  row_anno$group <- factor(row_anno$group, 
                           levels = c("AFR", "EAS", "SAS", "EUR", "AMR"))
  
  print(row_order)
  
  print(row_anno)
  
  # 1. Named color vector
  
  
  groups <- unique(row_anno$group)
  
  cols <- setNames(RColorBrewer::brewer.pal(5, "Set2"), c("AFR", "EAS", "SAS", "EUR", "AMR"))
  
  
  # Named vector for scale_color_manual
  row_colors <- setNames(cols, groups)
  
  # 2. Heatmap plot
  a <- ggplot(df, aes(x = pop1, y = pop2, fill = proportion * 100)) +
    geom_tile() +
    scale_fill_viridis_c(limits = c(0, 100)) +
    coord_equal(clip = "off") +
    theme_classic() +
    theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      legend.key = element_blank(),
      legend.background = element_blank(),
      axis.line = element_blank(),
      plot.margin = margin(t = 10, r = 10, b = 40, l = 40)
    ) +
    labs(fill = "Percent\nhotspots\nshared") +
    
    # Row labels
    geom_text(
      data = row_anno,
      aes(x = row, y = 0, label = row, color = group),
      inherit.aes = FALSE,
      vjust = 0, hjust = 0.8, angle = 90,
      show.legend = FALSE
    ) +
    
    # Column labels
    geom_text(
      data = row_anno,
      aes(x = 0, y = row, label = row, color = group),
      inherit.aes = FALSE,
      vjust = 0.3, hjust = 0.8, angle = 0,
      show.legend = FALSE
    ) +
    
    # Dummy geom_point for legend only
    geom_point(
      data = data.frame(group = groups),  
      aes(x = 1, y = 1, color = group),   
      inherit.aes = FALSE,
      shape = 15, size = 5,
      show.legend = TRUE
    ) +
    
    geom_tile() +
    
    scale_color_manual(values = cols,
                       name = "Continental\nGroup") 
  
  out_name <- paste0("heatamp_", thresh, "x.png")
  ggsave(out_name, dpi = 300)
}



