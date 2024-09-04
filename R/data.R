
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




