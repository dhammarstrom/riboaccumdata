
#' Ribosome accumulation-study: Participants
#'
#' Participant sex, baseline characteristics, group and leg allocation.
#'
#'
#' @format A data frame with 19 rows and 8 variables:
#' \describe{
#'   \item{participant}{Participant id}
#'   \item{group}{experiment, Experimental group; control, non-training control group}
#'   \item{age}{age in years}
#'   \item{height}{body stature in cm}
#'   \item{weight}{body mass in kg}
#'   \item{sex}{M, male; F, female}
#'   \item{R}{Training condition allocated to right leg: const, constant volume
#'   (6 sets of knee-extension) over the whole training period; var, variable
#'   volume ov the training period (6 sets during session 1-4, 3 sets during
#'   sessions 5-8 and 9 sets during sessions 9-12.); ctrl_leg, control condition leg.}
#'   \item{L}{Training condition allocated to left leg: const, constant volume
#'   (6 sets of knee-extension) over the whole training period; var, variable
#'   volume ov the training period (6 sets during session 1-4, 3 sets during
#'   sessions 5-8 and 9 sets during sessions 9-12.); ctrl_leg, control condition leg.}
#'   }
"ra_participants"

#' Ribosome accumulation-study: Protein data.
#'
#' Relative protein abundance data measured using immuno-blotting. Protein was
#' extracted from muscle tissue samples following RNA extraction using a standard
#' Trizol protocol (see Details).
#'
#' All samples from each participant were analyzed on one gel/blot, with replicates
#' per participants analyzed in new experiments. The total protein stain (Pierce™
#' Reversible Protein Stain Kit for PVDF Membranes) was used to normalize signals
#' from specific protein targets. Signals were detected using chemiluminescence
#' after bindning of specific antibodies to the membrane and subsequent binding
#' of secondary HRP-conjugated antibody.
#'
#' Total-protein and target-specific signals are normalized to maximum signals per
#' gel as exposure times, antibody affinity etc. differs between experiments.
#' These signals are "uncalibrated" between gels but can be used to investigate
#' changes across time/condition within participants and differences in change
#' across participants/groups under the assumption that signal intensity and protein
#' abundance is linear across gels.
#'
#' A set of calibration samples are available for t-s6 and t-UBF. One sample per
#' participant was measured on a calibration gel to allow for comparisons in
#' relative signals across participants. The `cal` variable includes the relative
#' signal of the calibration sample per participant. The `cal_sample` indicates which
#' sample to use for calibration.
#'
#' @format A data frame with 2435 rows and 12 variables:
#' \describe{
#'   \item{participant}{Participant identification}
#'   \item{sample}{Tissue sample identification}
#'   \item{leg}{R, right; L, left}
#'   \item{cond}{Experimental condition}
#'   \item{time}{Sampling time-point. S0, before the intervention; S1 S4, S5,
#'   S8, S9 and S12, 48 hours after sessions 1, 4, 5, 8, 9, and 12; post1w,
#'   8 days after session 12; S1c 48 h control period; postctrl, 2-4 week control
#'   period}
#'   \item{gel}{gel/immunoblot identification}
#'   \item{target}{Protein target}
#'   \item{total_protein}{Scaled signal for well-specific total protein content.
#'   The signal is scaled to gel maximum}
#'   \item{signal}{Target specific signals, scaled to gel maximum.}
#'   \item{expression}{signal divided by total protein. May be used for quantitative
#'   analysis of protein abundance changes}
#'   \item{cal_sample}{Sample identificator for the calibration sample}
#'   \item{cal}{Calibration signal for the calibration sample. To calculate
#'   a calibrated signal use y_cal = (y_i / cal_sample) * cal after protein
#'   normalisation}
#'   }
"ra_protein"


#' Ribosome accumulation study: Quantitative PCR data
#'
#' Relative cDNA abundance of selected RNA-targets.
#'
#'
#' @format A data frame with 9613 rows and 10 variables:
#' \describe{
#'   \item{participant}{Participant identification}
#'   \item{leg}{R, right; L, left}
#'   \item{time}{Sampling time-point. S0, before the intervention; S1 S4, S5,
#'   S8, S9 and S12, 48 hours after sessions 1, 4, 5, 8, 9, and 12; post1w,
#'   8 days after session 12; S1c 48 h control period; postctrl, 2-4 week control
#'   period}
#'   \item{sex}{Participant sex. Male, M; Female, F.}
#'   \item{cond}{Experimental condition}
#'   \item{target}{Gene target (see ra_reagents for details)}
#'   \item{cq}{Quantification cycle, corresponding to the second derivate
#'   maximum (see Spiess for details)}
#'   \item{eff}{Amplification efficiency per target, target average.}
#'   \item{cdna}{cDNA preparation (1 or 2)}
#'   \item{tissue_weight}{Weight (mg) of tissue used for analysis}
#'   }
"ra_qpcr"

#' Total RNA and muscle weight data
#'
#' @format A data frame with 1134 rows and 7 variables:
#' \describe{
#'   \item{participant}{participant identification}
#'   \item{series}{Extraction series. A subset of participants had replicate tissue
#'   samples extracted these are represented as 1 and 2 udner series}
#'   \item{sample}{Sample identification number. Samples were randomly assigned
#'   an id during RNA extraction and processing.}
#'   \item{leg}{R, right; L, left}
#'   \item{well}{Well for spectrophotometrical evaluation of RNA concentration}
#'   \item{RNA}{Estimated total amount of RNA extracted from muscle samples (ng)}
#'   \item{weight}{Muscle tissue weight (mg)}
#' }
"ra_totalrna"


#' Tissue samples for RNA extraction
#'
#' @format A data frame with 269 rows and 6 variables:
#' \describe{
#'   \item{participant}{participant identification}
#'   \item{leg}{R, right; L, left}
#'   \item{time}{Sampling time-point. S0, before the intervention; S1 S4, S5,
#'   S8, S9 and S12, 48 hours after sessions 1, 4, 5, 8, 9, and 12; post1w,
#'   8 days after session 12; S1c 48 h control period; postctrl, 2-4 week control
#'   period}
#'   \item{series}{Extraction series. A subset of participants had replicate tissue
#'   samples extracted these are represented as 1 and 2 udner series}
#'   \item{sample}{Sample identification number. Samples were randomly assigned
#'   an id during RNA extraction and processing.}
#'   \item{cond}{Experimental condition}
#' }
"ra_tissuesamples"


#' Ribosome accumulation study: Exercise training data
#'
#'
#' Resistance training was performed for the lower extremities using unilateral
#' leg extension. The load was adopted to reach the target number of repetitions.
#'
#'
#' @format A data frame with 1578 rows and 9 variables:
#' \describe{
#'   \item{participant}{participant identification}
#'   \item{session}{Session number (1-12)}
#'   \item{week}{Training week number (1-3)}
#'   \item{leg}{R, right; L, left}
#'   \item{set}{Set number}
#'   \item{repetitions}{Number of repetitions in set}
#'   \item{load}{External load in each set (kg)}
#'   \item{set_load}{Total volume in each set, number of repetitions multipled with load}
#' }
"ra_training"


#' Ribosome accumulation study: Strength testing data
#'
#'
#' Strength tests were performed before the intervention in
#' two independent sessions. During one of the sessions two
#' attempts were given for each test resulting in three
#' measured attempts.
#'
#'
#' @format A data frame with 172 rows and 7 variables:
#' \describe{
#'   \item{participant}{participant identification}
#'   \item{time}{Time-point for strength measurement. In the control group
#'   (`cond == ctrl_leg`), strength was measured before (baseline) and
#'   after the control period (`post_ctrl`). In the experimental
#'   group strength was measured before and after the intervention (`baseline`,
#'   `post`), and after the 8 day de-training period (`post1w`)}
#'   \item{leg}{R, right; L, left}
#'   \item{cond}{Experimental condition}
#'   \item{isok}{Knee extension Isokinetic torque at 60 degree per second}
#'   \item{isom}{Knee extension isometric torque}
#' }
"ra_strength"


#' Ribosome accumulation study: Muscle thickness
#'
#' Muscle thickness of m. vastus lateralis was measured using
#' a B-mode ultra sound device (SmartUS EXT-1M, telemed, Vilnius, Lithuania)
#' using a 39 mm, 12 MHz probe. The probe was placed perpendicular to a site
#' located 60% of the distance between Spina Iliac Anterior Superior and
#' the lateral femur condyle. Transmission gel was applied an care was taken not
#' to pressing the skin. The thickness measurement (mm) is the average of
#' three digital measurements (ImageJ Fiji).
#'
#'
#' @format A data frame with 98 rows and 5 variables:
#' \describe{
#'   \item{participant}{participant identification}
#'   \item{time}{Time-point for ultra sound measurements (US). In the control group
#'   (`cond == ctrl_leg`), US was measured before (baseline) and
#'   after the control period (`post_ctrl`). In the experimental
#'   group US was measured before and after the intervention (`baseline`,
#'   `post`), and after the 8 day de-training period (`post1w`)}
#'   \item{leg}{R, right; L, left}
#'   \item{cond}{Experimental condition}
#'   \item{thickness}{Vastus lateralis muscle thickness (mm)}
#' }
"ra_us"





