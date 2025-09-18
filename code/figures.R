################################################################################
# FIGURES
# called by main.R
# uses .Rdata files stored in ~/output/Rdata
################################################################################

################################################################################
### Loading all .RData files
################################################################################

setwd(path_rdata)
for (d in list.files(pattern = "\\.[Rr][Dd][Aa][Tt][Aa]$")) {
  load(d)
}



setwd(path_figures)

##### Figure 1: Pre-trend plot (Patent Quantity)

# Plot pre-trend plot for patent quantity
pplot <- ggdid(pre_trend_quant) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(
    title = "Figure 1. Dynamic Treatment Effects on Number of Patents (log)",
    x = "Year",
    y = "ATT",
    caption = "Note: ATT estimates with city and year fixed effects. Error bars represent 95% confidence intervals."
  )
ggsave("fig1.png", plot = pplot, width = 8, height = 6, dpi = 300)


##### Figure 2: Pre-trend plot (Patent Quality)

# Plot pre-trend plot for patent quality
pplot <- ggdid(pre_trend_qual)+ 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(
    title = "Figure 2. Dynamic Treatment Effects on Proportion of Novel Patents (%)",
    x = "Year",
    y = "ATT",
    caption = "Note: ATT estimates with city and year fixed effects. Error bars represent 95% confidence intervals."
  )
ggsave("fig2.png", plot = pplot, width = 8, height = 6, dpi = 300)
