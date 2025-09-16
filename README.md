# Hindered Creativity? The Effects of China’s Golden Shield Project on Innovation

**Author:** Chuhan Tang  

---

## Overview
This README contains instructions for replicating the results in *“Hindered Creativity? The Effects of China’s Golden Shield Project on Innovation”*. All results referenced in the paper can be replicated by running one file in R: `main.R`. This launches the estimation of various specifications used in the paper and produces the figures and tables.

---

## Data Availability and Provenance

### Statement about Rights
- The author certifies legitimate access to and permission to use the data in this manuscript.

### Summary of Availability
- All data **are** publicly available.

### Details on Each Data Source

| Data Name                  | Data Files               | Location          | Provided | Citation         |
|----------------------------|------------------------|-----------------|----------|----------------|
| City-level Patent Data     | patent_raw.dta         | data/raw/       | TRUE     | Ang et al. (2023) |
| China's City Codes         | China_city_codes.xlsx  | data/raw/       | TRUE     | Wang et al. (2021) |

---

## Computational Requirements

### Software Requirements
- R 4.3.2  
- Packages:
  - `dplyr` (1.1.4)  
  - `haven` (2.5.4)  
  - `tidyverse` (2.0.0)  
  - `xtable` (1.8.4)  
  - `readxl` (1.4.3)  
  - `ggplot2` (3.5.2)  
  - `did` (2.1.2)  
  - `fixest` (0.12.1)  
  - `modelsummary` (2.3.0)  
- The file `libraries.R` will install all dependencies and should be run once prior to running other programs.

---

## Instructions to Replicators
- Running `main.R` replicates all estimations and generates figures and tables.  
- Users need to set `path0`, the path of the `gsp_innov` folder.  
- Figures and tables are saved in `gsp_innov/output/figures` and `gsp_innov/output/tables`.

---

## Details of Files

### Launcher
- `gsp_innov/main.R`: launches all `.R` files in `gsp_innov/code/`, including `libraries.R`, `dataset.R`, `estimation.R`, `figures.R`, and `tables.R`.  
  - Users must set `path0`.

### Estimation File
- `estimation.R` (in `gsp_innov/code/`): performs all estimations.  
  - Data is saved in `gsp_innov/output/RData`.

### Figure- or Table-Generating Programs
- These scripts generate figures and tables and require results from `estimation.R`.
  - `figures.R` → generates Figures 1 and 2, saved in `gsp_innov/output/figures`.
  - `tables.R` → generates Tables 1, 2, and 3, saved in `gsp_innov/output/tables`.

### Support Files
- `libraries.R`: loads all required packages, installing any that are missing.
- `dataset.R`: assembles the dataset used in estimation.
  - Uses raw data in `gsp_innov/data/raw/`
  - Saves the dataset as `patent_data.csv` in `gsp_innov/data/transformed/`
