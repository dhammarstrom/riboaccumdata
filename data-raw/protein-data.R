

# Western blot (protein) data sets ##########################################




library(readxl); library(tidyverse)



# 2 Western blot data #######################################################


western_data_round1 <- read_excel("./data-raw/wetlab/tr010_western_round1.xlsx",
                                  na = "NA", sheet = "total_protein") %>%
  filter(participant != "LADDER") %>%
  dplyr::select(participant, ExtractionNR, round, gel, well, mean.gray1:total.protein2) %>%
  inner_join(read_excel("./data-raw/wetlab/tr010_mRNASamples_round1.xlsx", na = "NA") %>%
               dplyr::select(participant, leg, time, ExtractionNR)) %>%
  inner_join(read_excel("./data-raw/wetlab/tr010_western_round1.xlsx", na = "NA", sheet = "ecl") %>%
               dplyr::select(round, gel, well, target, signal)) %>%
  mutate(gel = paste0(round,"_", gel),
         sample = paste0(participant, "_", ExtractionNR)) %>%
  rowwise() %>%
  ### memcode stain - background = total protein ###
  mutate(total.protein = mean(c(total.protein1, total.protein2)) - mean(c(mean.gray1, mean.gray2, mean.gray3))) %>%
  ungroup() %>%
  dplyr::select(participant,sample, leg, time, gel, well, target, total.protein, signal, round) %>%
  group_by(gel) %>%
  ### Normalizes the total protein stain per
  mutate(tp.factor = total.protein) %>%
  inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
  dplyr::select(participant,sample, leg, cond, sex, time, gel, well, target, tp.factor, signal, round) %>%
  mutate(expression = signal / tp.factor) %>%
  print()


western_data_round2 <- read_excel("./data-raw/wetlab/tr010_western_round2.xlsx", na = "NA", sheet = "total_protein") %>%

  dplyr::select(participant, ser, num, round, gel, well, total.protein_1:meangray_4) %>%
  mutate(num = as.character(num)) %>%
  inner_join(read_csv2("./data-raw/wetlab/extraction_numbers_round2.csv", na = "NA") %>%
               dplyr::select(participant, leg, time, extraction_nr) %>%
               separate(extraction_nr, into = c("ser", "num"), sep = ":") %>%
               mutate(ser = as.numeric(if_else(ser == "I", 1, 2)))) %>%
  inner_join(read_excel("./data-raw/wetlab/tr010_western_round2.xlsx", na = "NA", sheet = "ecl") %>%
               dplyr::select(round, gel, well, target = Image, signal = Signal)) %>%



  mutate(target = gsub("_.*", "", target),
         target = if_else(target == "rpS6", "t-s6", "t-UBF"),
         gel = paste0(round,"_", gel),
         sample = paste0(participant, "_", ser, "_", num)) %>%

  rowwise() %>%
  ### memcode stain - background = total protein ###
  mutate(total.protein = mean(c(total.protein_1, total.protein_2)) - mean(c(meangray_1, meangray_2, meangray_3, meangray_4))) %>%
  ungroup() %>%
  dplyr::select(participant, sample, leg, time, gel, well, target, total.protein, signal, round) %>%
  group_by(gel) %>%
  ### Normalizes the total protein stain per
  mutate(tp.factor = total.protein) %>%
  inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
  dplyr::select(participant, sample, leg, cond, sex, time, gel, well, target, tp.factor, signal, round) %>%
  ungroup() %>%
  mutate(expression = signal / tp.factor,
         round = as.character(round)) %>%
  print()



# Calibration gel #############################################################


cal_gel <- read_excel("./data-raw/wetlab/tr010_calibration.xlsx") %>%

  mutate(participant = paste0("P", participant)) %>%

  inner_join(
    bind_rows(

      read_excel("./data-raw/wetlab/tr010_mRNASamples_round1.xlsx", na = "NA") %>%
        dplyr::select(participant, leg, time, ExtractionNR),
      read_csv2("./data-raw/wetlab/extraction_numbers_round2.csv", na = "NA") %>%
        dplyr::select(participant, leg, time, extraction_nr) %>%
        separate(extraction_nr, into = c("ser", "num"), sep = ":") %>%
        mutate(ser = as.numeric(if_else(ser == "I", 1, 2)),
               ExtractionNR = as.numeric(num)) %>%
        dplyr::select(participant, leg, time, ExtractionNR)
    )
  ) %>%
  rowwise() %>%
  mutate(background = mean(background1:background4, na.rm = TRUE),
         total.protein = mean(mean.gray1:mean.gray3, na.rm = TRUE),
         tp.factor = total.protein - background,
         sample = paste0(participant, "_", ExtractionNR)) %>%
  dplyr::select(participant:well, sample, leg, time, tp.factor, `t-UBF`, `t-s6`) %>%
  pivot_longer(names_to = "target",
               values_to = "signal",
               cols = `t-UBF`:`t-s6`) %>%

  inner_join(read_excel("./data-raw/leg_randomization.xlsx")) %>%
  dplyr::select(participant, sample, leg, cond, sex, time, gel, well, target, tp.factor, signal, round) %>%
  mutate(expression = signal / tp.factor) %>%

  # Include only experimental group samples
  filter(!(participant %in% paste0("P", 9:18))) %>%

  group_by(gel, target) %>%
  # Calculation of a calibration factor, scale each
  # calibration sample to the average signal.
  mutate(cal = expression / mean(expression, na.rm = TRUE)) %>%
  ungroup() %>%
  filter(gel == "cal1") %>%
  dplyr::select(participant, sample, target, cal) %>%
  mutate(cal_sample = sample) %>%
  print()



# Per gel normalization:
# Due to differences in memcode/ecl between gels expression is normalized to
# gel averages

# Uncalibrated signals, does not allow for "baseline" differences between
# participants
ra_protein <- rbind(western_data_round1,
                      western_data_round2) %>%
  group_by(gel, target) %>%
  mutate(tp.factor = tp.factor / max(tp.factor, na.rm = TRUE),
         signal = signal / max(signal, na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(expression = signal / tp.factor ) %>%
  group_by(target) %>%
  dplyr::select(participant, sample, leg, cond,
                time, gel, target,
                total_protein = tp.factor,
                signal,
                expression) %>%

  left_join(select(cal_gel, participant, target, cal_sample, cal)) %>%

  group_by(participant, target) %>%
  mutate(cal = mean(cal, na.rm = TRUE)) %>%
  ungroup() %>%
  print()


## Save data set ##
usethis::use_data(ra_protein, overwrite = TRUE)







