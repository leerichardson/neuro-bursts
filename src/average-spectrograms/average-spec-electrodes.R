# Lee F. Richardson
# Purpose: Write out a Spectrogram for each electrode, each trial
devtools::load_all("/home/lee/Dropbox/swdft/r/swdft")

bursts <- R.matlab::readMat("/home/lee/Dropbox/neuro-bursts/data/ToyData.mat")[[1]]

output_dir <- "/home/lee/Dropbox/neuro-bursts/outputs/avg-spectrograms"
num_electrodes <- dim(bursts)[2]
num_trials <- dim(bursts)[3]
window_size <- 2^9

## Loop over each trial, and save a Spectrogram for each one
for (electrode in 1:num_electrodes) {

  elec_path <- file.path(output_dir, paste0("elec", electrode))
  if (!dir.exists(elec_path)) { cat("Creating ", elec_path, " \n"); dir.create(elec_path) }

  for (trial in 1:num_trials) {

    cat("electrode: ", electrode, " trial: ", trial, " \n")

    ## Take the Multitaper SWDFT of this signal and save the output as an .rds file
    signal <- bursts[, electrode, trial]
    a <- swdft::swdft(x=signal, n=window_size, type="multitaper") * (1 / sqrt(window_size))

    output_path <- file.path(elec_path, paste0("trial_", trial, "_winsize_", window_size, ".rds"))
    saveRDS(object=a, file=output_path)
  }

}


