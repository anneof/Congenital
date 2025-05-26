

# Direct age standardised rate using Dobson method ------------------------






pacman::p_load(
  rio,                 # import/export data
  here,                # locate files
  stringr,             # cleaning characters and strings
  frailtypack,         # needed for dsr, for frailty models
  PHEindicatormethods, # alternative for rate standardisation
  epitools,... =       # epidemiological tests
  dbplyr,              # data managemen
  magritter,           # for pipe operator
  tidyverse,           # data manaegement
  openxlsx,            # read and import excel files
  Writexl,             # export data to excel
  ggplot, )           # data management 

# Import data -------------------------------------------------------------


congenital1<- import(("congenital3.xlsx"))


# Age standardised rate using PHEindicator methods package ----------------



congenital_rates<- congenital1 %>%
  group_by(year, sex, age_cat5) %>%
  PHEindicatormethods::phe_dsr(
    x = events,                 # column with observed number of events
    n = population,             # column with non-standard pops for each stratum
    stdpop = pop,               # standard populations for each stratum
    stdpoptype = "field")       # either "vector" for a standalone vector or "field" meaning std populations are in the data


# Print output as nice-looking HTML table
knitr::kable(congenital_rates) 

setwd ("Users/anneofarrell/Congenital malformations")

write.csv(congenital_rates, "age_std_rates")

writexl:: write_xlsx("congenital_rates")

install.packages("WriteXLS")

write_xls (congenital_rates, "age_rates")

export (congenital_rates, "congen_rates.xlsx")
