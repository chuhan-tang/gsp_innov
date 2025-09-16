################################################################################
# USEFUL LIBRARIES
# called by main.R
# packages are automatically installed if missing
################################################################################

options(warn = -1)
required_packages <- c("dplyr", "haven", "tidyverse", "xtable", "readxl",
                       "ggplot2", "did", "fixest", "modelsummary")
for (pkg in required_packages) {
  # if (!requireNamespace(pkg, quietly = TRUE)) {
  #  install.packages(pkg)
  #}
  library(pkg, character.only = TRUE)
}