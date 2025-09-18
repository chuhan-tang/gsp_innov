################################################################################
# MAIN LAUNCHER
################################################################################

rm(list = ls())
closeAllConnections()

# Set path in which the gsp_innov project is located
path0 <- '/Users/chuhantang/Documents/Research'

# Other paths
path1 <- paste0(path0,'/gsp_innov')
path_code <- paste0(path1,'/code')
path_data <- paste0(path1,'/data')
path_raw <- paste0(path_data,'/raw')
path_trans <- paste0(path_data,'/transformed')
path_output <- paste0(path1,'/output')
path_figures <- paste0(path_output,'/figures')
path_tables <- paste0(path_output, '/tables')
path_rdata <- paste0(path_output,'/RData')


# Running all codes in order

codes <- c("libraries.R",
           "dataset.R",
           "estimation.R",
           "figures.R",
           "tables.R")

setwd(path_code)
for (code in codes) {
  source(file.path(path_code, code), echo = TRUE, print.eval = TRUE)
}