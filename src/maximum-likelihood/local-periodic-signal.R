# Lee Richardson
# November 2, 2018
# Purpose: Compare the Maximum Likelihood estimates of a local periodic signal with the true parameters
devtools::load_all("/home/lee/Dropbox/swdft/r/swdft")

N <- 128
n <- 2^5
A <- 1
Fr <- 16
phase <- 1
S <- 30
L <- 62
sigma <- 1
noise <- rnorm(n=N, mean=0, sd=sigma)
signal <- swdft::local_signal(N=N, A=A, Fr=Fr, phase=phase, S=S, L=L)
x <- signal + noise

fit <- swdft::fit_burst(x=x, n=n)
max_loglik_fit <- fit[which.max(fit$Loglik),]

fitted_vals <- swdft::local_signal(N=N, A=max_loglik_fit$Ahat, Fr=max_loglik_fit$Fhat,
                                   phase = max_loglik_fit$Phihat, S = max_loglik_fit$S,
                                   L = max_loglik_fit$L)

# --- Plot the true time-series vs. the fitted values ---
png("/home/lee/Dropbox/neuro-bursts/doc/beta-bursts-methodology/images/local-signal-example.png")

  par(mfrow=c(2, 1))

  plot(0:(N-1), x, pch=19, cex=.8, ylim=c(-4, 4),
       xlab="Time", ylab="", main="Local Periodic Signal + Noise")
  lines(0:(N-1), signal, col="red", lwd=2)
  lines(0:(N-1), fitted_vals, col="blue", lwd=2, lty=1)
  legend("topleft", c("True Signal", "Estimated Signal"), cex=.75, col=c("red", "blue"), lwd=2)

  xpad <- c(rep(0, n-1), x)
  a <- swdft::swdft(x=xpad, n=n) * (1 / sqrt(n))
  amod <- Mod(a)^2
  plot_swdft(a=a, title="Sliding Window DFT (e.g. Spectrogram) of the Time-Series",
             use_fields=FALSE, only_unique=TRUE, custom_xaxis=0:127, col="other")

dev.off()

# --- Plot the justification for S and L ---

## Compute the range of F to numerically search
max_amod_inds <- which(amod==max(amod), arr.ind=TRUE)

khat <- max_amod_inds[1, 1]
phat <- max_amod_inds[1, 2]

Fmin <- (khat - 1) * (N / n); cat("Fmin: ", Fmin, " \n")
Fmax <- (khat + 1) * (N / n); cat("Fmax: ", Fmax, " \n")

## Estimate the starting locations (S and L) of the periodic signal
thresh <- 5
seq_above_thresh <- get_seq_above(amod[khat, ], phat, thresh)

S_range <- max(seq_above_thresh[1] - n, 0):seq_above_thresh[1]
num_above_thresh <- (seq_above_thresh[2] - seq_above_thresh[1])
L_range <- (num_above_thresh - n):num_above_thresh

  png("/home/lee/Dropbox/neuro-bursts/doc/beta-bursts-methodology/images/numerical-params.png")

    par(mfrow=c(1,1))

    plot(amod[khat, ], pch=19, ylab="Squared Modulus", xlab="Window Position",
         main="Frequency khat Time-Series")
    abline(v=phat, col="red", lwd=2)
    abline(h=thresh, col="blue", lwd=2)
    abline(v=seq_above_thresh[1], col="green", lwd=2)
    abline(v=seq_above_thresh[2], col="green", lwd=2)
    legend("topleft", c("Maximum (phat)", "Threshold", "pmin, pmax"), cex=1,
           col=c("red", "blue", "green"), lwd=2)

  dev.off()

