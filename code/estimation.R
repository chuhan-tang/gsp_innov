################################################################################
# ESTIMATION FILE
# called by main.estimation.R
################################################################################

################################################################################
### DATA IMPORT
################################################################################

setwd(path_trans)
patent <- read_csv('patent_data.csv')

##### Estimation 1: Summary statistics

# Variable lables
var_labels <- c(
  popugrowth = "Population growth",
  year = "Year",
  lngdppc = "GDP per capita (log)",
  fdishare = "FDI/GDP",
  lngdp_province = "Provincial GDP (log)",
  lnpatent_count = "Number of patents (log)",
  patent_novelshare = "Proportion of novel patents (%)",
  post = "After 2005",
  treated = "GSP Phase 1 Implemented (2005)"
)

# Select all numerical variables except for city and province codes
num_data <- patent %>%
  select(where(is.numeric), -citycode, -provincecode, -treated_year)

# Create summary stats
summary_stats <- num_data %>%
  summarise(across(everything(),
                   list(
                     Observations = ~sum(!is.na(.x)),
                     Mean = ~mean(.x, na.rm = TRUE),
                     StdDev = ~sd(.x, na.rm = TRUE),
                     Min = ~min(.x, na.rm = TRUE),
                     Max = ~max(.x, na.rm = TRUE)
                   ),
                   .names = "{.col}_{.fn}")) %>%
  pivot_longer(
    everything(),
    names_to = c("Variable", ".value"),
    names_pattern = "^(.*)_(Observations|Mean|StdDev|Min|Max)$"
  )

summary_stats$Variable <- var_labels[summary_stats$Variable]


##### Estimation 2: Pre-trend plot (Patent Quantity)

pre_trend_quant <- att_gt(
  yname = "lnpatent_count",
  tname = "year",
  idname = "citycode",
  gname = "treated_year",
  data = patent,
  xformla = ~ lngdppc + fdishare + popugrowth,
  control_group = "notyettreated",
  allow_unbalanced_panel = TRUE
)


##### Estimation 3: Pre-trend plot (Patent Quality)

pre_trend_qual <- att_gt(
  yname = "patent_novelshare",
  tname = "year",
  idname = "citycode",
  gname = "treated_year",
  data = patent,
  xformla = ~ lngdppc + fdishare + popugrowth,
  control_group = "notyettreated",
  allow_unbalanced_panel = TRUE
)


##### Estimation 4: Baseline DiD Regressions

did_quant <- feols(lnpatent_count ~ treated*post + lngdppc + fdishare + popugrowth | citycode + year,
                   data = patent, cluster = "citycode")

did_qual <- feols(patent_novelshare ~ treated*post + lngdppc + fdishare + popugrowth | citycode + year,
                  data = patent, cluster = "citycode")


##### Estimation 5: Staggered DiD Regressions

stag_quant <- aggte(pre_trend_quant, type = 'group')
stag_qual <- aggte(pre_trend_qual, type = 'group')

stag_quant <- data.frame(
  Estimate = stag_quant$att,
  StdError = stag_quant$se,
  t.value = stag_quant$att/stag_quant$se
)

stag_qual <- data.frame(
  Estimate = stag_qual$att,
  StdError = stag_qual$se,
  t.value = stag_qual$att/stag_qual$se
)


#########################         SAVE RDATA         ###########################

setwd(path_rdata)

save(summary_stats, file = "summary_stats.RData")
save(pre_trend_quant, file = "pre_trend_quant.RData")
save(pre_trend_qual, file = "pre_trend_qual.RData")
save(did_quant, file = "did_quant.RData")
save(did_qual, file = "did_qual.RData")
save(stag_quant, file = "stag_quant.Rdata")
save(stag_qual, file = "stag_qual.Rdata")