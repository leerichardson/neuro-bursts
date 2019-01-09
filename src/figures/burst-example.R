# Lee Richardson
# Purpose: Generate Figure w/ Cananoical Example of a "Burst"
# Output: Figure with a Burst

library(R.matlab)
library(l1tf)
library(genlasso)
devtools::load_all("/home/lee/Dropbox/swdft/r/swdft")

bursts <- R.matlab::readMat("/home/lee/Dropbox/neuro-bursts/data/ToyData.mat")[[1]]
trial_info <- read.csv("/home/lee/Dropbox/neuro-bursts/data/trialInfo.csv", stringsAsFactors=FALSE)
time_range <- 1:4500
time <- seq(-2, 5, by=.001)[time_range]
window_size <- 2^9

## Extract example Burst + SWDFT of this Burst
burst_orig <- bursts[time_range, 6, 16]

## Detrend the Time-series
trend_filter <- l1tf::l1tf(x=burst_orig, prop=.005)
burst <- burst_orig - trend_filter
# ### Can use different order trend filters, but don't understand well enough
# trend_filter_gl <- genlasso::trendfilter(y=burst_orig, ord=3)
# burst_ord3 <- burst - trend_filter_gl$fit[, 400]

## Standardize the Time-Series
burst <- (burst - mean(burst)) / sd(burst)

## Take the SWDFT of the pre-processed time-series
a <- swdft::swdft(x=burst, n=window_size, type="fftw")  * (1 / sqrt(window_size))


png("/home/lee/Dropbox/neuro-bursts/outputs/figures/sample-burst.png", width=900, height=720)

  par(mfrow=c(2, 1))

  plot(time, burst_orig, pch=19, cex=.4, xlab="Time (ms)", ylab="",
       main="LFP Signal for Electrode 6, Trial 16")
  lines(time, trend_filter, col="red", lwd=3)
  plot_swdft(a=a, col="other", custom_xaxis=time, hertz=TRUE, fs=1000, hertz_range=c(0, 100),
             xlab="Time (ms)", title="Multitaper SWDFT of a Local Field Potential (LFP) Time-Series")

dev.off()
