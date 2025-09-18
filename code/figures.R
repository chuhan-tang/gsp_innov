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

#### Figure 1: Parallel Trend (Patent Quantity)
pplot <- ggplot(
  patent %>%
    group_by(year, treated) %>%
    summarise(mean_lnpatent = mean(lnpatent_count, na.rm = TRUE), .groups = "drop"),
  aes(x = year, y = mean_lnpatent, color = factor(treated))
) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 2005, linetype = "dashed", color = "black") +
  labs(
    title = "Figure 1: Trends in Patent Quantity by Treatment Status",
    x = "Year",
    y = "Mean Number of patents (log)",
    color = "Treated",
    caption = "Note: The figure plots the averages of treated and control cities' logged number of patents over time.
Dashed line marks the introduction of treatment in 2005."
  ) +
  theme_minimal(base_size = 14)
# Save as picture
ggsave("fig1.png", plot = pplot, width = 10, height = 6, dpi = 300)

#### Figure 2: Parallel Trend (Patent Quality)
pplot <- ggplot(
  patent %>%
    group_by(year, treated) %>%
    summarise(mean_patent_novelshare = mean(patent_novelshare, na.rm = TRUE), .groups = "drop"),
  aes(x = year, y = mean_patent_novelshare, color = factor(treated))
) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = 2005, linetype = "dashed", color = "black") +
  labs(
    title = "Figure 2: Trends in Patent Quality by Treatment Status",
    x = "Year",
    y = "Mean Share of novel patents (%)",
    color = "Treated",
    caption = "Note: The figure plots averages of treated and control cities' share of novel patents over time. 
Dashed line marks the introduction of treatment in 2005."
  ) +
  theme_minimal(base_size = 14)
# Save as picture
ggsave("fig2.png", plot = pplot, width = 10, height = 6, dpi = 300)

##### Figure 3: Event study plot (Patent Quantity)

# Plot pre-trend plot for patent quantity
pplot <- ggdid(pre_trend_quant) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(
    title = "Figure 3: Dynamic Treatment Effects on Number of Patents (log)",
    x = "Year",
    y = "ATT",
    caption = "Note: ATT estimates with city and year fixed effects. Error bars represent 95% confidence intervals."
  )
# Save as picture
ggsave("fig3.png", plot = pplot, width = 8, height = 6, dpi = 300)


##### Figure 4: Event study plot (Patent Quality)

# Plot event study plot for patent quality
pplot <- ggdid(pre_trend_qual)+ 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  labs(
    title = "Figure 4: Dynamic Treatment Effects on Proportion of Novel Patents (%)",
    x = "Year",
    y = "ATT",
    caption = "Note: ATT estimates with city and year fixed effects. Error bars represent 95% confidence intervals."
  )
# Save as picture
ggsave("fig4.png", plot = pplot, width = 8, height = 6, dpi = 300)
