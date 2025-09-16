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

# Output summary stats

print(
  xtable(summary_stats, caption = "Table 1. Summary Statistics"),
  type = "html",
  file = "tab1.html",
  include.rownames = FALSE,
  html.table.attributes = 'border="0" style="width: 50%; border-collapse: collapse;"',
  caption.placement = "top",
  add.to.row = list(
    pos = list(0),  # 0 = after header row
    command = "<tr style='border-bottom: 2px solid black;'></tr>"
  )
)

##### Table 2: DiD Regression Table

did_table <- etable(
  list(
    "Number of patents (log)" = did_quant,
    "Proportion of novel patents (%)" = did_qual
  ),
  tex = TRUE,
  title = "Table 2. Baseline DiD Regressions",
  digits = 3,
  dict = c(
    "treated:post" = "Treated × Post",
    "lngdppc" = "Log GDP per capita",
    "fdishare" = "FDI/GDP",
    "popugrowth" = "Population Growth",
    "year" = "Year",
    "citycode" = "City"
  )
)

did_table <-  paste0(
  "\\documentclass[12pt]{article}\n",
  "\\usepackage{booktabs}\n",
  "\\usepackage[margin=1in]{geometry}\n",
  "\\usepackage{lmodern}\n",
  "\\usepackage{amsmath}\n",
  "\\usepackage{float}\n",
  "\\begin{document}\n",
  paste(did_table, collapse = "\n"),
  "\n\\end{document}"
)


# Save tex and export as pdf
cat(did_table, file = "tab2.tex")
latexmk("tab2.tex")

##### Table 3: Staggered DiD Regressions

# Create a dataframe
stag_table <- data.frame(
  Metric = c("Estimate", "StdError", "T-value"),
  `Number-of-patents`  = c(stag_quant$Estimate, stag_quant$StdError, stag_quant$t.value),
  `Proportion-of-novel-patents`   = c(stag_qual$Estimate, stag_qual$StdError, stag_qual$t.value)
)


# Convert the dataframe into xtable, then tex lines

stag_table_tex <- print(xtable(stag_table, 
             caption = "Table 3. Staggered DiD Results", 
             label = "tab:stag_did"),
      type = "latex", 
      include.rownames = FALSE,
      sanitize.text.function = identity, 
      print.results = FALSE)

# Wrap the tex lines with necessary latex set up
stag_table_tex <- paste0(
  "\\documentclass[12pt]{article}\n",
  "\\usepackage{booktabs}\n",
  "\\usepackage[margin=1in]{geometry}\n",
  "\\usepackage{lmodern}\n",
  "\\usepackage{amsmath}\n",
  "\\usepackage{float}\n",
  "\\begin{document}\n",
  stag_table_tex,
  "\n\\end{document}"
)

# Save tex and export as pdf
writeLines(stag_table_tex, "tab3.tex")
latexmk("tab3.tex")
