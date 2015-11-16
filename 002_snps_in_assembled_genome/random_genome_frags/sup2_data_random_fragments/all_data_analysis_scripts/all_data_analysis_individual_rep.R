# load libraries and data
library(ggplot2)
library(quantchem)
source('~/git-hub-repos/shyamrallapalli/mutations_hts_noref/lib/zero_ratio_adj.R')


frags <- read.delim(file="fragments_with_mut_ids.txt", header = TRUE)
colnames(frags) <- c("iterations", "fragment")

dir = getwd()
dir = paste(dir, "vars_infrags", sep='/')
dir.create("barplots_selected")
## read all files in a folder and store to a dataframe
filelist = list.files(dir, "^genome_")
#for (i in 1:length(filelist)) {
for (i in 1:10) {
  filename = paste(dir, filelist[i], sep='/')
  newdf <- read.delim(file=filename, header = TRUE)
  newdf$vars = newdf$numhm + newdf$numht
  selected = subset(newdf, vars > 0)
  selected$position <- cumsum(selected$length)
  selected <- re_zero_ratio(selected, 0.5)
  selected$adjratio <- selected$ratio/selected$length

  # fit polynomial to combined data
  lmfit2 <- lm(selected$ratio ~ poly(selected$position, 2, raw=TRUE))
  lmfit3 <- lm(selected$ratio ~ poly(selected$position, 3, raw=TRUE))
  lmfit4 <- lm(selected$ratio ~ poly(selected$position, 4, raw=TRUE))
  lmfit5 <- lm(selected$ratio ~ poly(selected$position, 5, raw=TRUE))
  lmfit6 <- lm(selected$ratio ~ poly(selected$position, 6, raw=TRUE))

  iteration = gsub("_varinfo.txt$", "", filelist[i])
  fragid = as.character(frags[which(frags$iterations == iteration),]$fragment)
  selected = within(selected, {
    color=ifelse(fragment==fragid, "red", "black")
    width=ifelse(fragment==fragid, 30, 0.5)})

  # print models to pdf
  filename1 = paste("barplots_selected/ratio_", filelist[i], "_barplot.pdf", sep='')
  pdf(filename1,width=6,height=4)
  barplot(selected$ratio, width=selected$width, col=selected$color, border=selected$color)
  lines(predict(lmfit2, data.frame(x=selected$position)), col="red")
  lines(predict(lmfit3, data.frame(x=selected$position)), col="blue")
  lines(predict(lmfit4, data.frame(x=selected$position)), col="green")
  lines(predict(lmfit5, data.frame(x=selected$position)), col="orange")
  lines(predict(lmfit6, data.frame(x=selected$position)), col="grey")
  dev.off()

  # fit polynomial to combined data
  lmfit2 <- lm(selected$adjratio ~ poly(selected$position, 2, raw=TRUE))
  lmfit3 <- lm(selected$adjratio ~ poly(selected$position, 3, raw=TRUE))
  lmfit4 <- lm(selected$adjratio ~ poly(selected$position, 4, raw=TRUE))
  lmfit5 <- lm(selected$adjratio ~ poly(selected$position, 5, raw=TRUE))
  lmfit6 <- lm(selected$adjratio ~ poly(selected$position, 6, raw=TRUE))

  # print models to pdf
  filename2 = paste("barplots_selected/adjratio_", filelist[i], "_barplot.pdf", sep='')
  pdf(filename2,width=6,height=4)
  barplot(selected$adjratio, width=selected$width, col=selected$color, border=selected$color)
  lines(predict(lmfit2, data.frame(x=selected$position)), col="red")
  lines(predict(lmfit3, data.frame(x=selected$position)), col="blue")
  lines(predict(lmfit4, data.frame(x=selected$position)), col="green")
  lines(predict(lmfit5, data.frame(x=selected$position)), col="orange")
  lines(predict(lmfit6, data.frame(x=selected$position)), col="grey")
  dev.off()


  # qunatchem fit to combined data and save curves to pdf
#  fit = lmcal(selected$position, selected$ratio)

#  filename2 = paste(filelist[i], "_quantchem_fitplot.pdf", sep='')
#  pdf(filename2,width=7,height=7)
#  par(mfrow=c(4,5))
#  plot(fit, type = "curve", xlab = "position", ylab = "ratio")
#  dev.off()

}
