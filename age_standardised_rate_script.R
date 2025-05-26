pacman::p_load(
  rio,                 # import/export data
  here,                # locate files
  stringr,             # cleaning characters and strings
  frailtypack,         # needed for dsr, for frailty models
  PHEindicatormethods, # alternative for rate standardisation
  epitools,
  dbplyr,
  dplyr,
  magritter,
  tidyverse)           # data management and visualization

# Import data -------------------------------------------------------------
 
congenital <- import(("data_congenital.csv"))



?phe_dsr



rates <- congenital %>%
  group_by(year, sex, age_cat5) %>%
  PHEindicatormethods::phe_dsr(
    x = events                 # column with observed number of events
    n = Population,             # column with non-standard pops for each stratum
    stdpop = pop)               # standard populations for each stratum
    stdpoptype = "field")       # either "vector" for a standalone vector or "field" meaning std populations are in the data  
