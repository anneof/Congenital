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
pacman::p_load(rio) 


A_demo <- import("https://github.com/appliedepi/epirhandbook_eng/raw/master/data/standardization/country_demographics.csv")

# import deaths for country A directly from Github
A_deaths <- import("https://github.com/appliedepi/epirhandbook_eng/raw/master/data/standardization/deaths_countryA.csv")

# import demographics for country B directly from Github
B_demo <- import("https://github.com/appliedepi/epirhandbook_eng/raw/master/data/standardization/country_demographics_2.csv")

# import deaths for country B directly from Github
B_deaths <- import("https://github.com/appliedepi/epirhandbook_eng/raw/master/data/standardization/deaths_countryB.csv")

# import standardised population
standard_pop_data <- import("https://github.com/appliedepi/epirhandbook_eng/raw/master/data/standardization/world_standard_population_by_sex.csv")

library(rio)

# Country A
A_demo <- import(("country_demographicsA.csv"))


# Country B
B_demo <- import(("country_demographicsB.csv"))

# Standard pop data
standard_pop_data<- import(("Standard_pop.csv"))



# Clean data --------------------------------------------------------------

library(dplyr)
library(dbplyr)
library (tidyverse)


pop_countries <- A_demo %>%  # begin with country A dataset
  bind_rows(B_demo) %>%        # bind rows, because cols are identically named
  pivot_longer(                       # pivot longer
    cols = c(m, f),                   # columns to combine into one
    names_to = "Sex",                 # name for new column containing the category ("m" or "f") 
    values_to = "Population") %>%     # name for new column containing the numeric values pivoted
  mutate(Sex = recode(Sex,            # re-code values for clarity
                      "m" = "Male",
                      "f" = "Female"))
# Pivot longer to combine death_country data

deaths_countries <- A_deaths %>%     # begin with country A deaths dataset
  bind_rows(B_deaths) %>%        # bind rows with B dataset, because cols are identically named
  pivot_longer(                  # pivot longer
    cols = c(Male, Female),        # column to transform into one
    names_to = "Sex",              # name for new column containing the category ("m" or "f") 
    values_to = "Deaths") %>%       # name for new column containing the numeric values pivoted
  rename (age_cat5 = AgeCat)      # rename for clarity

# Join data - add deaths to table ---------------------------------------------

country_data <- pop_countries %>% 
  left_join (deaths_countries, by = c("Country", "age_cat5", "Sex"))



# Clean standard_pop_data
standard_pop_clean <- standard_pop_data %>% 
  
  rename(pop = WorldStandardPopulation)   # change col name to "pop", as this is expected by dsr package


# Join all data tables
all_data <- left_join(country_data, standard_pop_clean, by=c("age_cat5", "Sex"))

?phe_dsr


age_and_sex_std_rate <- all_data %>%
  group_by(Country, Sex, age_cat5) %>%
  PHEindicatormethods::phe_dsr(
    x = Deaths,                 # column with observed number of events
    n = Population,             # column with non-standard pops for each stratum
    stdpop = pop,               # standard populations for each stratum
    stdpoptype = "field")       # either "vector" for a standalone vector or "field" meaning std populations are in the data  
