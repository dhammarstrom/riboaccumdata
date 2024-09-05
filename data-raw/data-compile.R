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
# 4. Total RNA data





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


# Source qpcr compilation (estimated to ~ 15 min run time)
# source("data-raw/qpcr-data.R")

# 4. Total RNA data ########################################################


source("total-rna.R")


# 5. Tissue samples, time and conditions

ra_tissuesamples <- bind_rows(
  read_excel("./data-raw/tr010_mRNASamples.xlsx") %>%
  mutate(series = 1) %>%
  select(participant, leg, time, series, sample = ExtractionNR),

read.csv2("./data-raw/wetlab/extraction_numbers_round2.csv") %>%
  separate(extraction_nr, into = c("series", "sample")) %>%
  mutate(series = if_else(series == "I", 1, 2)) %>%
  select(participant, leg, time, series, sample) %>%
  mutate(sample = as.numeric(sample))
) %>%
  inner_join(read_excel("./data-raw/leg_randomization.xlsx", na = "NA") %>%
               mutate(sex = toupper(sex))) %>%
  select(-sex)

usethis::use_data(ra_tissuesamples, overwrite = TRUE)

# 5. Training data #########################################################




ra_training <- read_excel("./data-raw/tr010_training.xlsx", sheet = 1, na = "NA") %>%
  inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
  filter(exercise == "legext") %>%
  mutate(set_load = repetitions * load,
         week = if_else(session %in% c(1:4), "W1", if_else(session %in% c(5:8), "W2", "W3"))) %>%
  select(participant, session, week, leg, set, repetitions, load, set_load) %>%
  print()


usethis::use_data(ra_training, overwrite = TRUE)






