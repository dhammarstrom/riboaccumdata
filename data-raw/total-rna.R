


########################  Total RNA from replicates ############################



# Total RNA estimates are loaded from replicates. Sample weights, participant,
# leg, sample id data are retrieved from different data sources and collected
# in a single data set. The ra_samples can be used to connect samples to
# time/condition
#

# Round 2 data: participants P18 (control), P19, P21-23.
# Round 1 data all other participants.




######## Round 2 data ################################################

library(tidyverse)
library(readxl)


files <- list.files("./data-raw/tot_rna/total-rna-replicates/")



results <- list()

for(i in 1:length(files)){


  results[[i]] <-  read_excel(paste0("./data-raw/tot_rna/total-rna-replicates/", files[i]), skip = 0, na = "NaN")


}


tot_rna <- bind_rows(results) %>%
  dplyr::select(well = Well, Sample, dilution = `Dilution factor`, concentration = ...7) %>%
  mutate(concentration = concentration * dilution) %>%
  dplyr::select(-dilution)



# Extraction numbers round 2

# Filter P18 and code samples
# Elution volume is 20 ul in P18.
p18_samples <- tot_rna %>%
  filter(Sample %in% paste0("P18-", rep(1:6))) %>%
  inner_join(data.frame(Sample = c("P18-1", "P18-2", "P18-3", "P18-4", "P18-5", "P18-6"),
                        sample = c("mRNA1","mRNA1", "mRNA2", "mRNA2", "mRNA2", "mRNA1" ),
                        time = c("postctrl", "S0", "S0", "postctrl", "S0", "S0"),
                        leg = c("L", "R", "L", "L", "R", "L"))) %>%
  mutate(concentration = ((concentration/3)/(50*(10/0.51))) * (40 *(10/0.51)) ,
         rna = concentration * 20) %>%
  inner_join(read_excel("./data-raw/tissue/tr010_tissue.xlsx", na = "NA") %>%
               filter(participant == "P18", sample != "prot")) %>%
  mutate(series = 1) %>%
  dplyr::select(well, participant, series, sample, leg, time, tissue_weight, rna) %>%
  print()



# Elution volume for P19, 21, 22, 23: 25 ul.
tot_rna_round2 <- tot_rna %>%
  filter(!(Sample %in% paste0("P18-", rep(1:6)))) %>%
  separate(Sample, into = c("participant", "series", "sample"), convert = TRUE) %>%
  inner_join(read.csv("./data-raw/wetlab/extraction_numbers_round2.csv", sep = ";") %>%
               separate(extraction_nr, into = c("series", "sample"), convert = TRUE) %>%
               mutate(series = if_else(series == "I", 1, 2))) %>%

  # Change concentration as this was estimated with the wrong factor in nanodrop
  # Calculations:
  # RNA = Absorbance * 40 * (10/0.51) * dilutionfactor (= 3)
  # [The above was mistakenly calculated as DNA in raw data:
  # DNA = Absorbance * 50 * (10/0.51)]
  mutate(concentration = ((concentration/3)/(50*(10/0.51))) * (40 *(10/0.51)) ,
         rna = concentration * 25) %>%
  dplyr::select(well, participant, series, sample, leg, time, tissue_weight, rna) %>%
  print()


tot_rna_round2 <- rbind(tot_rna_round2, p18_samples)



#################### Round 1 data ###############################################


sample_setup <- read_excel("./data-raw/tr010_mRNASamples.xlsx", na = "NA") %>%
  inner_join(read_excel("./data-raw/tissue/tr010_tissue.xlsx", na = "NA") %>%
               filter(sample == "mRNA") %>%
               mutate(date = as.Date(as.numeric(date), origin = "1899-12-30")) %>%
               dplyr::select(participant, leg, time, samplenr, date)) %>%
  filter(IncludeTotalRNA == "YES") %>%
  dplyr::select(participant, leg, time, ExtractionNR, tissue_weight, elution) %>%
  print()



### Read files from Total RNA measurements
files <- list.files("./data-raw/tot_rna/total-rna-raw-round1/")

results <- list()

for(i in 1:length(files)) {

  results[[i]] <- read_excel(paste0("./data-raw/tot_rna/total-rna-raw-round1/", files[i], sep = ""), na = "NA")

}

tot_rna_round1 <- bind_rows(results) %>%
  filter(Sample != "Blank1") %>%
  separate(Sample, c("participant", "ExtractionNR")) %>%
  dplyr::select(well = Well, participant, ExtractionNR, TotalRNA) %>%
  mutate(ExtractionNR = as.numeric(ExtractionNR)) %>%
  inner_join(sample_setup) %>%
  mutate(rna = TotalRNA * elution,
         series = 1) %>%
  dplyr::select(well, participant, series, sample = ExtractionNR, leg, time, tissue_weight, rna) %>%
  print()




############### Combined data set ###########################


ra_totalrna <- rbind(tot_rna_round1, tot_rna_round2) %>%
  filter(!is.na(tissue_weight)) %>%
  select(participant, series, sample, leg, well, RNA = rna, weight = tissue_weight) %>%
  print()


usethis::use_data(ra_totalrna, overwrite = TRUE)









