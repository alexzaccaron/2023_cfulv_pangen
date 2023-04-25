


pdf("plots/copia_element.pdf", width = 5, height = 3)

plot(1, type= 'n', xlim=c(0,6000), ylim=c(0,100), axes=F, xlab="", ylab="")
axis(1)

# LTRs
rect(119, 10, 359, 30, lwd = NA, col = "grey")
rect(5505, 10, 5745, 30, lwd = NA, col = "grey")

# GAG
rect(2309, 10, 2497, 30, lwd = NA, col = "purple")

# INT
rect(2546, 10, 2839, 30, lwd = NA, col = "gold")

# RV
rect(3935, 10, 4651, 30, lwd = NA, col = "darkgreen")

# RNase
rect(4937, 10, 5389, 30, lwd = NA, col = "cyan")


rect(1, 10, 5788, 30, lwd = 0.7)

dev.off()