# Lee F. Richardson
# Purpose: Analyze all individual Spectrograms for an individual Electrode
# Output: A image for each Spectrogram for each trial
devtools::load_all("/home/lee/Dropbox/swdft/r/swdft")
time <- seq(-2, 5, by=.001)

elec_output_dir <- "/home/lee/Dropbox/neuro-bursts/outputs/avg-spectrograms/individual-specs/elec1"
elec_files <- list.files("/home/lee/Dropbox/neuro-bursts/outputs/avg-spectrograms/elec1", full.names=TRUE)

running_max <- 0

for (spec_file in elec_files) {
  trial_num <- strsplit(x=spec_file, split="_")[[1]][2]
  cat("File: ", spec_file,  " Trial Num: ", trial_num, " \n")

  ## Read in the final Spectrogram
  spec <- readRDS(file=spec_file)
  max_spec <- max(Mod(spec)^2)
  running_max <- max(running_max, max_spec)
  print(running_max)

  ## Save an image of the Spectrogram averaged across 100 Trials
  png(filename=file.path(elec_output_dir, paste0("trial", trial_num, ".png")), width=720, height=540)

    plot_swdft(a=spec, col="other", hertz=TRUE, fs=1000, hertz_range=c(0, 100),
               custom_xaxis=time, xlab = "Time (ms)", # zlim=c(0, .005),
               title=paste0("Electrode 1, Trial ", trial_num))

  dev.off()
}
