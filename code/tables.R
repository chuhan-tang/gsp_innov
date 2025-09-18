################################################################################
# TABLES
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



setwd(path_tables)

##### Table 1: Summary statistics

# Convert the summary stats dataframe into xtable, then tex lines

summary_table_tex <- print(
  xtable(summary_stats, 
         caption = "Summary Statistics", 
         label = "tab:summary_stats"),
  type = "latex",
  include.rownames = FALSE,
  caption.placement = "top",
  sanitize.text.function = identity,
  print.results = FALSE
)

##### Table 2: DiD Regression Table

did_table_tex <- etable(
  list(
    "Number of patents (log)" = did_quant,
    "Proportion of novel patents (%)" = did_qual
  ),
  tex = TRUE,
  caption = "Baseline DiD Regressions",
  digits = 3,
  dict = c(
    "treated:post" = "Treated × Post",
    "lngdppc" = "Log GDP per capita",
    "fdishare" = "FDI/GDP",
    "popugrowth" = "Population Growth",
    "year" = "Year",
    "citycode" = "City"
  ),
  notes = "Note: All regressions include city and year fixed effects. Standard errors are clustered at the city level."
)


##### Table 3: Staggered DiD Regressions

# Create a dataframe
stag_table <- data.frame(
  Metric = c("Estimate", "StdError", "T-value"),
  `Number-of-patents`  = c(stag_quant$Estimate, stag_quant$StdError, stag_quant$t.value),
  `Proportion-of-novel-patents`   = c(stag_qual$Estimate, stag_qual$StdError, stag_qual$t.value)
)


# Convert the dataframe into xtable, then tex lines

stag_table_tex <- print(xtable(stag_table, 
             caption = "Staggered DiD Results", 
             label = "tab:stag_did"),
      type = "latex", 
      include.rownames = FALSE,
      caption.placement = "top",
      sanitize.text.function = identity, 
      print.results = FALSE)

##### Outputting tables
# Combine all tables' tex lines into one tex file, and wrap them with necessary latex set up

tables_tex <- paste0(
  "\\documentclass[12pt]{article}\n",
  "\\usepackage{booktabs}\n",
  "\\usepackage[margin=1in]{geometry}\n",
  "\\usepackage{lmodern}\n",
  "\\usepackage{amsmath}\n",
  "\\usepackage{float}\n",
  "\\begin{document}\n",
  summary_table_tex,
  "\n\\bigskip",
  "\\noindent\\footnotesize Note: Summary statistics are computed for available observations and show the mean, standard deviation, minimum, and maximum for each variable.\n",
  "\n\\bigskip",
  paste(did_table_tex, collapse = "\n"),
  "\n\\bigskip",
  stag_table_tex,
  "\\vspace{20cm}\n",
  "\\noindent\\footnotesize Note: Table 3 reports group-time Average Treatment Effects from a staggered difference-in-differences specification. Estimates are presented with standard errors and t-values. All regressions include city and year fixed effects.\n",
  "\\end{document}"
)

# Save tex and export as pdf

cat(tables_tex, file = "tabs.tex")
latexmk("tabs.tex")
