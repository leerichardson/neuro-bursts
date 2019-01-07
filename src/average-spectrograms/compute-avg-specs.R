# Lee F. Richardson
# Purpose: Average the written-out spectrograms in each trial
# Output: 10 Averaged Spectrograms and Plots for each electrode.
devtools::load_all("/home/lee/Dropbox/swdft/r/swdft")
time <- seq(-2, 5, by=.001)

## Specify the directory where I will be saving the results
averaged_dir <- "/home/lee/Dropbox/neuro-bursts/outputs/avg-spectrograms/averaged-specs"

electrode_dirs <- file.path("/home/lee/Dropbox/neuro-bursts/outputs/avg-spectrograms", paste0("elec", 1:10))

## Loop over all the outputted Spectroms for each electrode. Compute the average
## Spectrogram and a corresponding image.
for (edir in electrode_dirs) {
  electrode_num <- which( edir == electrode_dirs )
  cat("ELECTRODE NUMBER: ", electrode_num, " \n")

  ## Read in each Spectrogram in the directory
  edir_specs <- list.files(edir, full.names=TRUE)

  for (spec_file in edir_specs) {
    print(spec_file)
    spec <- readRDS(file=spec_file)

    ## If it's the first spectrogram in this directory, save it. If not,
    ## then average this spectrogram with the others
    if (spec_file == edir_specs[1]) {
      avg_spec <- spec
    } else {
      avg_spec <- avg_spec + spec
    }
  }

  ## Divde the Average Spectrogram by the total number of trial
  avg_spec <- avg_spec / length(edir_specs)

  ## Save the Average Spectrogram
  saveRDS(object=avg_spec, file=file.path(averaged_dir, paste0("elec", electrode_num, ".rds")))

  ## Save an image of the Spectrogram averaged across 100 Trials
  png(filename=file.path(averaged_dir, paste0("elec", electrode_num, ".png")), width=720, height=540)

    plot_swdft(a=avg_spec, col="other", hertz=TRUE, fs=1000, hertz_range=c(0, 100),
               custom_xaxis=time, xlab = "Time (ms)",
               title=paste0("Average Spectrogram Electrode ", electrode_num))

  dev.off()
}
