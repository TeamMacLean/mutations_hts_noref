# load libraries and data
library(ggplot2)
library(quantchem)
alldata <- read.delim(file="random_frag_contig_all_iterations_data.txt", header=TRUE)

# fit polynomial to combined data
lmfit2 <- lm(alldata$ratio ~ poly(alldata$position, 2, raw=TRUE))
lmfit3 <- lm(alldata$ratio ~ poly(alldata$position, 3, raw=TRUE))
lmfit4 <- lm(alldata$ratio ~ poly(alldata$position, 4, raw=TRUE))
lmfit5 <- lm(alldata$ratio ~ poly(alldata$position, 5, raw=TRUE))
lmfit6 <- lm(alldata$ratio ~ poly(alldata$position, 6, raw=TRUE))

# print models to pdf
pdf("lmfit_boxplot.pdf",width=6,height=4)
barplot(alldata$ratio)
lines(predict(lmfit2, data.frame(x=alldata$position)), col="red")
lines(predict(lmfit3, data.frame(x=alldata$position)), col="blue")
lines(predict(lmfit4, data.frame(x=alldata$position)), col="green")
lines(predict(lmfit5, data.frame(x=alldata$position)), col="orange")
lines(predict(lmfit6, data.frame(x=alldata$position)), col="grey")
dev.off()

# qunatchem fit to combined data and save curves to pdf
fit = lmcal(alldata$position, alldata$ratio)

pdf("quantchem_fitplot.pdf",width=7,height=7)
par(mfrow=c(4,5))
plot(fit, type = "curve", xlab = "position", ylab = "ratio")
dev.off()

pdf("quantchem_residuals.pdf",width=4,height=4)
boxplot(residuals(fit))
dev.off()
