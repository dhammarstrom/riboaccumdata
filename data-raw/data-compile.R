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
# 5. Training data
# 6. Strength tests
# 7. Ultra sound measurements




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


# 6. Strength tests #######################################################


ra_strength <- read_excel("./data-raw/tr010_humac.xlsx") %>%
  inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
  mutate(time = if_else(timepoint %in% c("B1", "B2", "fam"), "baseline", timepoint)) %>%

  dplyr::select(participant,
                time,
                leg,

                cond,
                isok = isokinetic_torque,
                isom = isometric_torque) %>%

  print()

usethis::use_data(ra_strength, overwrite = TRUE)



# 7. Ultra sound measurements #############################################




# Combine data sets
ra_us <- rbind(read_excel("./data-raw/ultrasound/ultrasound_data.xlsx") %>%
                   inner_join(read_csv("./data-raw/ultrasound/ultrasound_codekey.csv")) %>%
                   mutate(leg = gsub("VL", "", leg)) %>%
                   inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
                   dplyr::select(participant, time, leg, sex, cond, code, length) %>%
                   mutate(group = if_else(participant %in% paste("P", c(1:7,19:23), sep = ""), "experiment", "control")) %>%
                   group_by(participant, time, leg, sex, cond, group) %>%
                   summarise(thickness = mean(length, na.rm = TRUE)) %>%
                   ungroup(),
                 read_excel("./data-raw/ultrasound/ultrasound_data_2019.xlsx") %>%
                   inner_join(read_csv("./data-raw/ultrasound/ultrasound_codekey_2019.csv")) %>%
                   mutate(leg = gsub("VL", "", leg)) %>%
                   inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
                   dplyr::select(participant, time, leg, sex, cond, code, length) %>%
                   mutate(group = if_else(participant %in% paste("P", c(1:7, 19:23), sep = ""), "experiment", "control")) %>%
                   group_by(participant, time, leg, sex, cond, group) %>%
                   summarise(thickness = mean(length, na.rm = TRUE)) %>%
                   ungroup()) %>%

  mutate(time_pp = if_else(time == "post1w", "post", time),
         # The de-training period get its own coefficient
         detrain = if_else(time == "post1w" & group == "experiment", "detrain", "train"),
         # The effect of de training will be added to the model --within-- the intervention group
         detrain = factor(detrain, levels = c("train", "detrain")),
         time = factor(time, levels = c("pre", "post", "post1w")),
         time_pp = factor(time_pp, levels = c("pre", "post"))) %>%
  ## Match with strength data set
  mutate(time = if_else(time == "pre", "baseline",
                        if_else(time == "post" & group == "control", "post_ctrl", time))) %>%
  dplyr::select(participant, time, leg, cond, thickness) %>%



  print()


usethis::use_data(ra_us, overwrite = TRUE)


