# Lee F. Richardson
# Purpose: Initially load in the Toy Dataset
library(R.matlab)
bursts <- R.matlab::readMat("/home/lee/Dropbox/neuro-bursts/data/ToyData.mat")
trial_info <- read.csv("/home/lee/Dropbox/neuro-bursts/data/trialInfo.csv", stringsAsFactors=FALSE)
time <- seq(-2, 5, by=.001)

## Verify there are exactly 10 trials
stopifnot(nrow(trial_info) == 100)

## Plot a sample burst just to ensure that everything is accurate
devtools::load_all("/home/lee/Dropbox/swdft/r/swdft")

sample_burst <- bursts[[1]][,1,2]
sample_burst <- (sample_burst - mean(sample_burst)) / sd(sample_burst)

plot(time, sample_burst, pch=19, cex=.4)
lines(time, sample_burst)
abline(v=c(0, .5, 2.5))


a_dft <- fft(sample_burst[1:2000])
plot( log(Mod(a_dft)^2), pch=19, cex=.5 )

a_dft_delay <- fft(sample_burst[2500:4500])
plot( log(Mod(a_dft_delay)^2), pch=19, cex=.5 )

window_size <- 512
a_swdft <- swdft::swdft(x=sample_burst, n=window_size)
swdft::plot_swdft(a=a_swdft[2:200, ], col="other", take_log=TRUE)

