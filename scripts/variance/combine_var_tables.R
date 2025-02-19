library(tidyverse)
library(ggplot2)
library(ggridges)

fname = "variance_tables/chr1.csv"
df <- read.csv(fname)

for (i in c(seq(1, 22), "X")){
  fname = paste0("variance_tables/chr", i, ".csv")
  df <- rbind(df, read.csv(fname))
}

df <- df[, c("Chr", "Start", "variance")] %>%
  arrange(desc(variance))

# head(df)
# 
# tail(df)

write.csv(df,
          "var_table_sorted.csv",
          row.names	= FALSE,
          quote = FALSE)