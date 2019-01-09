# Lee Richardson
# Purpose: Check the off-diagonal terms in Beta-Bursts application
# Output: Figure that compares L against the value of the off diagonal terms

N <- 256
t <- 0:(N-1)
S <- 30
L <- 10:200
Fr <- c(16, 18, 20)

lsum_df <- data.frame(matrix(data=NA, nrow=length(Fr) * length(L), ncol=3))
names(lsum_df) <- c("L", "Freq", "sumval")
lsum_df$L <- L

iter <- 0
for (fr in Fr) {
  sinvals <- sin(x = (4 * pi * fr * t) / N)

  for (l in L) {
    iter <- iter + 1

    lsum_df[iter, "sumval"] <- sum( sinvals[t >= S & t <= l] )
    lsum_df[iter, "Freq"] <- fr

  }
}

png("/home/lee/Dropbox/neuro-bursts/outputs/figures/off-diagonal.png", width=900, height=720)

  par(mfrow=c(1, 3))

  inds_f16 <- which(lsum_df$Freq == 16)
  inds_f18 <- which(lsum_df$Freq == 18)
  inds_f20 <- which(lsum_df$Freq == 20)

  plot(lsum_df$L[inds_f16], lsum_df$sumval[inds_f16], xlab="L", ylab="Value of Summation", type="p", pch=19,
       main = "Off-Diagonal Term for Frequency 16")
  lines(lsum_df$L[inds_f16], lsum_df$sumval[inds_f16])
  abline(h=0, lwd=2, col='red')

  plot(lsum_df$L[inds_f18], lsum_df$sumval[inds_f18], xlab="L", ylab="Value of Summation", type="p", pch=19,
       main = "Off-Diagonal Term for Frequency 18")
  lines(lsum_df$L[inds_f18], lsum_df$sumval[inds_f18])
  abline(h=0, lwd=2, col='red')

  plot(lsum_df$L[inds_f20], lsum_df$sumval[inds_f20], xlab="L", ylab="Value of Summation", type="p", pch=19,
       main = "Off-Diagonal Term for Frequency 20")
  lines(lsum_df$L[inds_f20], lsum_df$sumval[inds_f20])
  abline(h=0, lwd=2, col='red')

dev.off()
