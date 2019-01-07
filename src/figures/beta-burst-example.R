devtools::load_all(pkg = "/home/lee/Dropbox/swdft/r/swdft")
library(R.matlab)
bursts <- readMat("/home/lee/Dropbox/neuro-bursts/data/lfp_processed_lee.mat")

sampling_rate <- as.numeric(bursts$fs)
trial <- 10
one_trial <- bursts$y[4, , trial]
t <- as.numeric(bursts$tvec)
x <- one_trial - mean(one_trial)
N <- length(x)
n <- 2^10
unique_inds <- 2:(floor(N / 2))
freqs <- unique_inds / N
a <- fftwtools::fftw(data=x) * (1 / sqrt(N))
amod <- Mod(a)^2
a_mtm <- swdft::swdft_multitaper(x=x, n=n)


# Plot
png("/h")

  par(mfrow=c(2,1))
  plot(t, x, cex=.5, pch=19, xlab="Time (ms)", main=paste0("Local Field Potential (LFP) for Trail: ", ))
  lines(t, x, col="black", lwd=1)

  plot_swdft(a=a_mtm, take_log=FALSE, hertz=TRUE, fs=1000, hertz_range = c(0,100),
             col="other", custom_xaxis=t, pad_array=TRUE, xlab="Time (milliseconds)",
             use_fields=FALSE, title = "Multitaper SWDFT of Beta Band Frequencies")

dev.off()
