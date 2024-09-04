## Compile data sets from Ribo-accum study ##
##
##
##
##
##
##
#############################################


# 1. Participants (including leg randomization and baseline characteristics)
# 2. Western blot (protein) data
# 3. qPCR data






# 0. Packages etc. ##########################################################

library(tidyverse); library(readxl)





# 1. Participants ###########################################################


# Leg allocation table
legs <- read_excel("./data-raw/leg_randomization.xlsx") %>%
  select(participant, leg, cond) %>%
  pivot_wider(names_from = leg, values_from = cond) %>%
  print()


# Participant table
ra_participants <- read_excel("./data-raw/tr010_age_participant.xlsx") %>%
  inner_join(legs) %>%
  select(-comment) %>%
  print()


usethis::use_data(ra_participants, overwrite = TRUE)


# 2. Western blot data ######################################################


source("data-raw/protein-data.R")



# 3. qPCR (RNA) data set ###################################################














