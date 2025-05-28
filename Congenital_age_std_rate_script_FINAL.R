

# Direct age standardised rate script with sample data --------------------

# Author: AOF

# Source; Epihandbook on CRAN

# install the latest version of the Epi R Handbook package
pacman::p_install_gh("appliedepi/epirhandbook")

# load the package for use
pacman::p_load(epirhandbook)


# download the offline handbook to your computer
download_book()

# Install packages --------------------------------------------------------


pacman::p_load(
  rio,                 # import/export data
  here,                # locate files
  stringr,             # cleaning characters and strings
  frailtypack,         # needed for dsr, for frailty models
  PHEindicatormethods, # alternative for rate standardisation
  epitools,
  dplyr,
  magritter,
  tidyverse, 
  ggplot)           # data management and visualization

install.packages("BiocManager")
install.packages("usethis")

install.packages("magrittr") # package installations are only needed the first time you use it
install.packages("dplyr")    # alternative installation of the %>%
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
# The dsr package is in the archive  - use this code  to retrieve  --------


# Set working directory ---------------------------------------------------

setwd("C:/Users/anneofarrell/Desktop/CONGENITAL")


# Import data -------------------------------------------------------------


congenital1<- import(("congenital_raw.xlsx"))


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



write.csv(congenital_rates, "age_std_rates")

writexl:: write_xlsx("congenital_rates")

install.packages("WriteXLS")

write_xls (congenital_rates, "age_rates")

export (congenital_rates, "congen_rates.xlsx")








